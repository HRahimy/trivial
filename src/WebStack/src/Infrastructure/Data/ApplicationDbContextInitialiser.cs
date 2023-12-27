using System.Runtime.InteropServices;
using Trivial.Domain.Constants;
using Trivial.Domain.Entities;
using Trivial.Infrastructure.Identity;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Trivial.Domain.Enums;

namespace Trivial.Infrastructure.Data;

public static class InitialiserExtensions
{
    public static async Task InitialiseDatabaseAsync(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();

        var initialiser = scope.ServiceProvider.GetRequiredService<ApplicationDbContextInitialiser>();

        await initialiser.InitialiseAsync();

        await initialiser.SeedAsync();
    }
}

public class ApplicationDbContextInitialiser
{
    private readonly ILogger<ApplicationDbContextInitialiser> _logger;
    private readonly ApplicationDbContext _context;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;

    public ApplicationDbContextInitialiser(ILogger<ApplicationDbContextInitialiser> logger, ApplicationDbContext context, UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager)
    {
        _logger = logger;
        _context = context;
        _userManager = userManager;
        _roleManager = roleManager;
    }

    public async Task InitialiseAsync()
    {
        try
        {
            await _context.Database.MigrateAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while initialising the database.");
            throw;
        }
    }

    public async Task SeedAsync()
    {
        try
        {
            await TrySeedAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while seeding the database.");
            throw;
        }
    }

    public async Task TrySeedAsync()
    {
        // Default roles
        var administratorRole = new IdentityRole(Roles.Administrator);

        if (_roleManager.Roles.All(r => r.Name != administratorRole.Name))
        {
            await _roleManager.CreateAsync(administratorRole);
        }

        // Default users
        var administrator = new ApplicationUser { UserName = "administrator@localhost", Email = "administrator@localhost" };

        if (_userManager.Users.All(u => u.UserName != administrator.UserName))
        {
            await _userManager.CreateAsync(administrator, "Administrator1!");
            if (!string.IsNullOrWhiteSpace(administratorRole.Name))
            {
                await _userManager.AddToRolesAsync(administrator, new[] { administratorRole.Name });
            }
        }

        // Quizzes
        if (!_context.Quizzes.Any())
        {
            _context.Quizzes.Add(new Quiz
            {
                Name = "World of Warcraft",
                Description = "Test your knowledge of the World of Warcraft lore. For beginners to the universe.",
                Duration = new TimeSpan(0, 0, 15, 30),
                Difficulty = QuizDifficulty.Normal,
                Questions =
                {
                    new QuizQuestion
                    {
                        Question = "Who was the High Chieftain of the Tauren before Baine Bloodhoof",
                        SequenceIndex = 1,
                        Options =
                        {
                            new QuestionOption { Value = QuestionOptionIndex.A, Description = "Cairne Bloodhoof", IsAnswer = true },
                            new QuestionOption { Value = QuestionOptionIndex.B, Description = "Varok Saurfang", IsAnswer = false },
                            new QuestionOption { Value = QuestionOptionIndex.C, Description = "Tamalaa Bloodhoof", IsAnswer = false },
                            new QuestionOption { Value = QuestionOptionIndex.D, Description = "Elder Bloodhoof", IsAnswer = false },
                        }
                    },
                    new QuizQuestion
                    {
                        Question = "Which of these creatures are native to Elwynn Forest?",
                        SequenceIndex = 2,
                        Options =
                        {
                            new QuestionOption { Value = QuestionOptionIndex.A, Description = "Quillboar", IsAnswer = false },
                            new QuestionOption { Value = QuestionOptionIndex.B, Description = "Murlocs", IsAnswer = true },
                            new QuestionOption { Value = QuestionOptionIndex.C, Description = "Tauren", IsAnswer = false },
                            new QuestionOption { Value = QuestionOptionIndex.D, Description = "Dreadlords", IsAnswer = false },
                        }
                    },
                    new QuizQuestion
                    {
                        Question = "Which of these creatures are native to Elwynn Forest?",
                        SequenceIndex = 2,
                        Options =
                        {
                            new QuestionOption { Value = QuestionOptionIndex.A, Description = "Quillboar", IsAnswer = false },
                            new QuestionOption { Value = QuestionOptionIndex.B, Description = "Murlocs", IsAnswer = true },
                            new QuestionOption { Value = QuestionOptionIndex.C, Description = "Tauren", IsAnswer = false },
                            new QuestionOption { Value = QuestionOptionIndex.D, Description = "Dreadlords", IsAnswer = false },
                        }
                    },
                }
            });
            _context.Quizzes.Add(new Quiz
            {
                Name = "Elder Scrolls",
                Description = "Test your knowledge of the Elder Scrolls lore. For beginners to the universe.",
                Duration = new TimeSpan(0, 15, 30),
                Difficulty = QuizDifficulty.Normal,
                //Questions =
                //{
                //    new QuizQuestion{Question = ""}
                //}
            });

            await _context.SaveChangesAsync();
        }
    }
}
