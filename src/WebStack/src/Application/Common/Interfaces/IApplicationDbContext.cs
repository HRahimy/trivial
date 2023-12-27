using Trivial.Domain.Entities;

namespace Trivial.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<Quiz> Quizzes { get; }
    DbSet<QuizQuestion> QuizQuestions { get; }
    DbSet<QuestionOption> QuestionOptions { get; }


    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
