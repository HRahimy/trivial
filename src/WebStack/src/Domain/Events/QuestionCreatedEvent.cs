namespace Trivial.Domain.Events;
public class QuestionCreatedEvent : BaseEvent
{
    public QuestionCreatedEvent(QuizQuestion question)
    {
        Question = question;
    }

    public QuizQuestion Question { get; }
}
