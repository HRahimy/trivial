namespace Trivial.Domain.Entities;
public class Quiz : BaseAuditableEntity
{
    public Quiz()
    {
        Duration = new TimeSpan(0, 20, 0);
    }
    public string Name { get; set; }
    public string? Description { get; set; }
    public QuizDifficulty Difficulty { get; set; }
    public TimeSpan Duration { get; set; }

    public IList<QuizQuestion> Question { get; private set; } = new List<QuizQuestion>();
}
