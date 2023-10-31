using Microsoft.AspNetCore.Mvc;
using Trivial.Application.Quizzes.Models;
using Trivial.Application.Quizzes.Commands.CreateQuiz;

namespace Trivial.WebUI.Controllers;

public class QuizzesController : ApiControllerBase
{

    [HttpPost]
    public async Task<ActionResult<QuizDto>> Create(CreateQuizCommand command)
    {
        return await Mediator.Send(command);
    }
}
