namespace Trivial.Domain.Events;
public class OptionCreatedEvent : BaseEvent
{
    public OptionCreatedEvent(QuestionOption option)
    {
        Option = option;
    }

    public QuestionOption Option { get; }
}
