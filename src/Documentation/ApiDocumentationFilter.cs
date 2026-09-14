using GuardianPet.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace GuardianPet.Documentation;

// Documentation only: authorization remains controlled by endpoint metadata.
public sealed class ApiDocumentationFilter : IDocumentFilter
{
    public void Apply(OpenApiDocument document, DocumentFilterContext context)
    {
        foreach (var description in context.ApiDescriptions)
        {
            var path = "/" + description.RelativePath?.Split('?')[0];
            if (!document.Paths.TryGetValue(path, out var item)) continue;
            var operation = item.Operations?.FirstOrDefault(pair =>
                string.Equals(pair.Key.Method, description.HttpMethod, StringComparison.OrdinalIgnoreCase)).Value;
            if (operation is null) continue;

            var metadata = description.ActionDescriptor.EndpointMetadata;
            var protectedEndpoint = metadata.OfType<IAuthorizeData>().Any()
                && !metadata.OfType<IAllowAnonymous>().Any();
            operation.Security = protectedEndpoint
                ? new List<OpenApiSecurityRequirement>
                {
                    new OpenApiSecurityRequirement
                    {
                        {
                            new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                                }
                            },
                            new string[] {}
                        }
                    }
                }
                : new List<OpenApiSecurityRequirement>();

            // Business validation and automatic model validation use different bodies.
            var businessValidation = (description.HttpMethod == "POST"
                && path is "/api/users" or "/api/veterinarians" or "/api/consultations")
                || (description.HttpMethod == "PUT" && path == "/api/consultations/{id}");
            if (businessValidation && operation.Responses?.ContainsKey("400") == true)
            {
                operation.Responses!["400"] = new OpenApiResponse
                {
                    Description = "Dados inválidos: validação do corpo ou regra de negócio.",
                    Content = new Dictionary<string, OpenApiMediaType>
                    {
                        ["application/json"] = new OpenApiMediaType
                        {
                            Schema = new OpenApiSchema
                            {
                                AnyOf = new List<OpenApiSchema>
                                {
                                    context.SchemaGenerator.GenerateSchema(typeof(ErrorResponse), context.SchemaRepository),
                                    context.SchemaGenerator.GenerateSchema(typeof(ValidationProblemDetails), context.SchemaRepository)
                                }
                            }
                        }
                    }
                };
            }
        }

        AddHealthPath(document, "/health", "Verifica se a API está ativa, sem consultar o Oracle.", false);
        AddHealthPath(document, "/health/ready", "Verifica a conectividade real com o Oracle usando AppDbContext.Database.CanConnectAsync().", true);
    }

    private static void AddHealthPath(OpenApiDocument document, string path, string summary, bool readiness)
    {
        var operation = new OpenApiOperation
        {
            Summary = summary,
            Description = "Acesso anônimo; não exige token JWT.",
            Security = new List<OpenApiSecurityRequirement>(),
            Responses = new OpenApiResponses { ["200"] = HealthResponse("Healthy") }
        };
        if (readiness) operation.Responses.Add("503", HealthResponse("Unhealthy: Oracle indisponível."));
        var item = new OpenApiPathItem();
        item.AddOperation(OperationType.Get, operation);
        document.Paths[path] = item;
    }

    private static OpenApiResponse HealthResponse(string description) => new()
    {
        Description = description,
        Content = new Dictionary<string, OpenApiMediaType>
        {
            ["text/plain"] = new OpenApiMediaType { Schema = new OpenApiSchema { Type = "string" } }
        }
    };
}