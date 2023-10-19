using Trivial.Application.Common.Interfaces;

namespace Trivial.Infrastructure.Services;

public class DateTimeService : IDateTime
{
    public DateTime Now => DateTime.Now;
}
