namespace Trivial.Domain.Entities;
public class Quiz : BaseAuditableEntity
{
    public string Name { get; set; }
    public string? Description { get; set; }
    public QuizDifficulty Difficulty { get; set; }

    public IList<QuizQuestion> Question { get; private set; } = new List<QuizQuestion>();
}
