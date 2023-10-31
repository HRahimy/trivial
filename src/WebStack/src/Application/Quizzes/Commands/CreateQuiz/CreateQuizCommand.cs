using AutoMapper;
using MediatR;
using Trivial.Application.Common.Interfaces;
using Trivial.Application.Quizzes.Models;
using Trivial.Domain.Entities;
using Trivial.Domain.Enums;
using Trivial.Domain.Events;

namespace Trivial.Application.Quizzes.Commands.CreateQuiz;
public record CreateQuizCommand : IRequest<QuizDto>
{
    public string Name { get; init; }
    public string? Description { get; init; }
    public QuizDifficulty Difficulty { get; init; }
}

public class CreateQuizCommandHandler : IRequestHandler<CreateQuizCommand, QuizDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;
    public CreateQuizCommandHandler(IApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<QuizDto> Handle(CreateQuizCommand request, CancellationToken cancellationToken)
    {
        var entity = new Quiz
        {
            Name = request.Name,
            Description = request.Description,
            Difficulty = request.Difficulty,
        };

        entity.AddDomainEvent(new QuizCreatedEvent(entity));

        _context.Quizzes.Add(entity);

        await _context.SaveChangesAsync(cancellationToken);

        return _mapper.Map<QuizDto>(entity);
    }
}
