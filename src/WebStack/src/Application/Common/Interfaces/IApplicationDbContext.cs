using Trivial.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Trivial.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<TodoList> TodoLists { get; }

    DbSet<TodoItem> TodoItems { get; }
    DbSet<Quiz> Quizzes { get; }
    DbSet<QuizQuestion> QuizQuestions { get; }
    DbSet<QuestionOption> QuestionOptions { get; }


    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
