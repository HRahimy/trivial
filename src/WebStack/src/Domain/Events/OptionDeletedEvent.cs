namespace Trivial.Domain.Events;
public class OptionDeletedEvent : BaseEvent
{
    public OptionDeletedEvent(QuestionOption option)
    {
        Option = option;
    }

    public QuestionOption Option { get; }
}
