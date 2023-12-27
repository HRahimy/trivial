namespace Trivial.Domain.Events;
public class QuizEditedEvent : BaseEvent
{
    public QuizEditedEvent(Quiz quiz)
    {
        Quiz = quiz;
    }

    public Quiz Quiz { get; }
}
