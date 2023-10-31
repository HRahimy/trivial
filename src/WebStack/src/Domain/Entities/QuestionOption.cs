namespace Trivial.Domain.Entities;
public class QuestionOption : BaseAuditableEntity
{
    public int QuizQuestionId { get; set; }
    public QuizQuestion QuizQuestion { get; set; } = null!;
    public QuestionOptionIndex Value { get; set; }
    public string Description { get; set; }
    public bool IsAnswer { get; set; } = false;
}
