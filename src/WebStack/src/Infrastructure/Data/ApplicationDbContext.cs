using System.Reflection;
using Trivial.Application.Common.Interfaces;
using Trivial.Domain.Entities;
using Trivial.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Trivial.Infrastructure.Persistence;

namespace Trivial.Infrastructure.Data;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>, IApplicationDbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Quiz> Quizzes => Set<Quiz>();
    public DbSet<QuizQuestion> QuizQuestions => Set<QuizQuestion>();
    public DbSet<QuestionOption> QuestionOptions => Set<QuestionOption>();


    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        base.OnModelCreating(builder);

        /* Below code adapted from:
            https://andrewlock.net/customising-asp-net-core-identity-ef-core-naming-conventions-for-postgresql/
            for applying snake case naming convention to EF Identity related entities
         */
        foreach (var entity in builder.Model.GetEntityTypes())
        {
            // Replace table names
            entity.SetTableName(entity.GetTableName()?.ToSnakeCase());

            // Replace column names            
            foreach (var property in entity.GetProperties())
            {
                property.SetColumnName(property.GetColumnName().ToSnakeCase());
            }

            foreach (var key in entity.GetKeys())
            {
                key.SetName(key.GetName()?.ToSnakeCase());
            }

            foreach (var key in entity.GetForeignKeys())
            {
                key.SetConstraintName(key.GetConstraintName()?.ToSnakeCase());
            }

            foreach (var index in entity.GetIndexes())
            {
                index.SetDatabaseName(index.GetDatabaseName()?.ToSnakeCase());
            }
        }
    }
}
