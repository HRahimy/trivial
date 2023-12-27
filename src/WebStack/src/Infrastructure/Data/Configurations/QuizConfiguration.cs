using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Trivial.Domain.Entities;

namespace Trivial.Infrastructure.Persistence.Configurations;
public class QuizConfiguration : IEntityTypeConfiguration<Quiz>
{
    public void Configure(EntityTypeBuilder<Quiz> builder)
    {
        builder.Property(e => e.Duration)
            .HasConversion<long>();
    }
}
