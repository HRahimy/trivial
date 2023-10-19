using Trivial.Application.Common.Mappings;
using Trivial.Domain.Entities;

namespace Trivial.Application.TodoLists.Queries.ExportTodos;

public class TodoItemRecord : IMapFrom<TodoItem>
{
    public string? Title { get; init; }

    public bool Done { get; init; }
}
