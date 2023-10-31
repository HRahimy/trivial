namespace Trivial.Domain.Events;
public class OptionEditedEvent : BaseEvent
{
    public OptionEditedEvent(QuestionOption option)
    {
        Option = option;
    }

    public QuestionOption Option { get; }
}
