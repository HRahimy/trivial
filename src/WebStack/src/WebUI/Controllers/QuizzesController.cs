using Microsoft.AspNetCore.Mvc;
using Trivial.Application.Quizzes.Models;
using Trivial.Application.Quizzes.Commands.CreateQuiz;
using Trivial.Application.Common.Models;
using Trivial.Application.Quizzes.Queries.GetPaginatedQuizzes;

namespace Trivial.WebUI.Controllers;

public class QuizzesController : ApiControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PaginatedList<QuizDto>>> Get([FromQuery] GetPaginatedQuizzesQuery query)
    {
        return await Mediator.Send(query);
    }

    [HttpPost]
    public async Task<ActionResult<QuizDto>> Create(CreateQuizCommand command)
    {
        return await Mediator.Send(command);
    }
}
