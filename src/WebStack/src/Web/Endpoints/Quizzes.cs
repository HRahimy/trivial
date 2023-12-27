using Microsoft.AspNetCore.Mvc;
using Trivial.Application.Common.Models;
using Trivial.Application.Quizzes.Commands.CreateQuiz;
using Trivial.Application.Quizzes.Models;
using Trivial.Application.Quizzes.Queries.GetPaginatedQuizzes;

namespace Trivial.Web.Endpoints;

public class Quizzes : EndpointGroupBase
{

    public override void Map(WebApplication app)
    {
        app.MapGroup(this)
            .MapGet(Get)
            .MapPost(Create);
    }

    public async Task<PaginatedList<QuizDto>> Get(ISender sender, [AsParameters] GetPaginatedQuizzesQuery query)
    {
        return await sender.Send(query);
    }

    public async Task<QuizDto> Create(ISender sender, CreateQuizCommand command)
    {
        return await sender.Send(command);
    }
}
