defmodule Credo.Check do
  @base_priority_map  %{ignore: -100, low: -10, normal: 1, high: +10, higher: +20}
  @base_category_exit_status_map %{
    consistency: 1,
    design: 2,
    readability: 4,
    refactor: 8,
    warning: 16,
  }

  @type t :: module

  defmacro __using__(opts) do
    quote do
      @behaviour Credo.Check

      alias Credo.Check
      alias Credo.Issue
      alias Credo.IssueMeta
      alias Credo.Priority
      alias Credo.Severity
      alias Credo.SourceFile
      alias Credo.Check.CodeHelper
      alias Credo.Check.Params
      alias Credo.CLI.ExitStatus

      def base_priority do
        unquote(to_priority(opts[:base_priority]))
      end

      def category do
        default = unquote(category_body(opts[:category]))
        default || :unknown
      end

      def run_on_all? do
        unquote(run_on_all_body(opts[:run_on_all]))
      end

      def explanation do
        Check.explanation_for(@explanation, :check)
      end

      def explanation_for_params do
        Check.explanation_for(@explanation, :params)
      end

      def format_issue(issue_meta, opts) do
        Check.format_issue(issue_meta, opts, category(), base_priority(), __MODULE__)
      end
    end
  end

  alias Credo.Check
  alias Credo.Issue
  alias Credo.IssueMeta
  alias Credo.Priority
  alias Credo.Severity
  alias Credo.SourceFile
  alias Credo.Check.CodeHelper

  @doc """
  Returns the base priority for the check.
  """
  @callback base_priority() :: integer

  @doc """
  Returns the category for the check.
  """
  @callback category() :: atom

  @callback run(source_file :: Credo.SourceFile.t, params :: Keyword.t) :: List.t

  @callback run_on_all?() :: boolean

  @callback explanation() :: String.t

  @callback explanation_for_params() :: Keyword.t

  @callback format_issue(issue_meta :: IssueMeta, opts :: Keyword.t) :: Issue.t

  def explanation_for(nil, _) do
    nil
  end
  def explanation_for(keywords, key) do
    keywords[key]
  end

  @doc """
  format_issue takes an issue_meta and returns an issue.
  The resulting issue can be made more explicit by passing the following
  options to `format_issue/2`:

  - `:priority`     Sets the issue's priority.
  - `:trigger`      Sets the issue's trigger.
  - `:line_no`      Sets the issue's line number.
                      Tries to find `column` if `:trigger` is supplied.
  - `:column`       Sets the issue's column.
  - `:exit_status`  Sets the issue's exit_status.
  - `:severity`     Sets the issue's severity.
  """
  def format_issue(issue_meta, opts, category, base_priority, check) do
    source_file = IssueMeta.source_file(issue_meta)
    params = IssueMeta.params(issue_meta)
    priority =
      case params[:priority] do
        nil -> base_priority
        val -> val |> Check.to_priority
      end
    exit_status =
      case params[:exit_status] do
        nil -> category |> Check.to_exit_status
        val -> val |> Check.to_exit_status
      end

    line_no = opts[:line_no]
    trigger = opts[:trigger]
    column = opts[:column]
    severity = opts[:severity] || Severity.default_value

    %Issue{
      priority: priority,
      filename: source_file.filename,
      message: opts[:message],
      trigger: trigger,
      line_no: line_no,
      column: column,
      severity: severity,
      exit_status: exit_status
    }
    |> add_line_no_options(line_no, source_file)
    |> add_custom_column(trigger, line_no, column, source_file)
    |> add_check_and_category(check, category)
  end

  defp add_check_and_category(issue, check, category) do
    %Issue{
      issue |
      check: check,
      category: category
    }
  end

  defp add_custom_column(issue, trigger, line_no, column, source_file) do
    if trigger && line_no && !column do
      %Issue{
        issue |
        column: SourceFile.column(source_file, line_no, trigger)
      }
    else
      issue
    end
  end

  defp add_line_no_options(issue, line_no, source_file) do
    if line_no do
      {_def, scope} = CodeHelper.scope_for(source_file, line: line_no)
      %Issue{
        issue |
        priority: issue.priority + priority_for(source_file, scope),
        scope: scope
      }
    else
      issue
    end
  end

  defp priority_for(source_file, scope) do
    scope_prio_map = Priority.scope_priorities(source_file)
    scope_prio_map[scope] || 0
  end



  defp category_body(nil) do
    quote do
      value =
        __MODULE__
        |> Module.split
        |> Enum.at(2)
      (value || :unknown)
      |> to_string
      |> String.downcase
      |> String.to_atom
    end
  end
  defp category_body(value), do: value

  @doc "Converts a given category to a priority"
  def to_priority(nil), do: 0
  def to_priority(atom) when is_atom(atom) do
    @base_priority_map[atom]
  end
  def to_priority(value), do: value

  @doc "Converts a given category to an exit status"
  def to_exit_status(nil), do: 0
  def to_exit_status(atom) when is_atom(atom) do
    @base_category_exit_status_map[atom]
    |> to_exit_status
  end
  def to_exit_status(value), do: value

  defp run_on_all_body(true), do: true
  defp run_on_all_body(_), do: false
end
