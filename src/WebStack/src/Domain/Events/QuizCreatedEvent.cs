namespace Trivial.Domain.Events;
public class QuizCreatedEvent : BaseEvent
{
    public QuizCreatedEvent(Quiz quiz)
    {
        Quiz = quiz;
    }

    public Quiz Quiz { get; }
}
