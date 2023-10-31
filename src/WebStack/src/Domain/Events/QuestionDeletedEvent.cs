namespace Trivial.Domain.Events;
public class QuestionDeletedEvent : BaseEvent
{
    public QuestionDeletedEvent(QuizQuestion question)
    {
        Question = question;
    }

    public QuizQuestion Question { get; }
}
