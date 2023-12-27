namespace Trivial.Domain.Events;
public class QuestionEditedEvent : BaseEvent
{
    public QuestionEditedEvent(QuizQuestion question)
    {
        Question = question;
    }

    public QuizQuestion Question { get; }
}
