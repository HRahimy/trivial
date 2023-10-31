using Trivial.Application.Common.Mappings;
using Trivial.Domain.Entities;

namespace Trivial.Application.Quizzes.Models;
public class QuizDto : IMapFrom<Quiz>
{
    public int Id { get; init; }
    public string Name { get; init; }
    public string? Description { get; init; }
}
