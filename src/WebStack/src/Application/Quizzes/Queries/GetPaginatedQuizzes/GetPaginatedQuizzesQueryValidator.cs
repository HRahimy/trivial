using FluentValidation;
using Trivial.Application.Quizzes.Queries.GetPaginatedQuizzes;

public class GetPaginatedQuizzesQueryValidator : AbstractValidator<GetPaginatedQuizzesQuery>
{
    public GetPaginatedQuizzesQueryValidator()
    {
        RuleFor(x => x.PageNumber)
            .GreaterThanOrEqualTo(1).WithMessage("PageNumber at least greater than or equal to 1.");

        RuleFor(x => x.PageSize)
            .GreaterThanOrEqualTo(1).WithMessage("PageSize at least greater than or equal to 1.");
    }
}
