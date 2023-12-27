using Trivial.Domain.Entities;

namespace Trivial.Application.Quizzes.Models;
public class QuizDto
{
    public int Id { get; init; }
    public string Name { get; init; } = "";
    public string? Description { get; init; }
    public TimeSpan Duration { get; init; }

    private class Mapping : Profile
    {
        public Mapping()
        {
            CreateMap<Quiz, QuizDto>();
        }
    }
}
