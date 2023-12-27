namespace Trivial.Domain.Events;
public class QuizDeletedEvent : BaseEvent
{
    public QuizDeletedEvent(Quiz quiz)
    {
        Quiz = quiz;
    }

    public Quiz Quiz { get; }
}
