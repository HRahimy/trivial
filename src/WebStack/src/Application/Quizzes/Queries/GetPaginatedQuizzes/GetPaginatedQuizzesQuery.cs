using Trivial.Application.Common.Interfaces;
using Trivial.Application.Common.Mappings;
using Trivial.Application.Common.Models;
using Trivial.Application.Quizzes.Models;

namespace Trivial.Application.Quizzes.Queries.GetPaginatedQuizzes;
public record GetPaginatedQuizzesQuery : IRequest<PaginatedList<QuizDto>>
{
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 10;
}

public class GetPaginatedQuizzesQueryHandler
    : IRequestHandler<GetPaginatedQuizzesQuery, PaginatedList<QuizDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;


    public GetPaginatedQuizzesQueryHandler(IApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<PaginatedList<QuizDto>> Handle(GetPaginatedQuizzesQuery request, CancellationToken cancellationToken)
    {
        return await _context.Quizzes
            .OrderBy(x => x.Created)
            .ProjectTo<QuizDto>(_mapper.ConfigurationProvider)
            .PaginatedListAsync(request.PageNumber, request.PageSize);
    }
}
