using FluentValidation;

namespace Trivial.Application.Quizzes.Commands.CreateQuiz;
public class CreateQuizCommandValidator : AbstractValidator<CreateQuizCommand>
{
    public CreateQuizCommandValidator()
    {
        // Name
        RuleFor(e => e.Name)
            .NotNull().WithMessage("Name is required")
            .NotEmpty().WithMessage("Name is required")
            .MinimumLength(3).WithMessage("Name must be at least 3 characters");

        RuleFor(e => e.Description)
            .MinimumLength(5)
                .When(e => !string.IsNullOrEmpty(e.Description))
                .WithMessage("Description must be at least 5 characters");

        // Difficulty
        RuleFor(e => e.Difficulty)
            .NotNull().WithMessage("Difficulty is required");

        // Duration
        RuleFor(e => e.Duration)
            .NotNull().WithMessage("Duration is required")
            .NotEmpty().WithMessage("Duration is required");
    }
}
