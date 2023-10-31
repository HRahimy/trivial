namespace Trivial.Domain.Entities;
public class QuizQuestion : BaseAuditableEntity
{
    public int QuizId { get; set; }
    public Quiz Quiz { get; set; } = null!;
    public required string Question { get; set; }
    public int SequenceIndex { get; set; }
    public IList<QuestionOption> Options { get; private set; } = new List<QuestionOption>();
}
