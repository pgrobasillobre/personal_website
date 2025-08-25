# debugpgi created

# Defines a module named PersonalWebsite.Content.

# This module:
#   Reads content files (markdown with YAML frontmatter)
#   Parses them into Elixir maps
#   Converts markdown to HTML
#   Sorts and formats them for display
#   Helps power things like blog sections, project listings, or a "Now" page

defmodule PersonalWebsite.Content do
  # Give absolute path to priv/content, which we have created
  @root Application.app_dir(:personal_website, "priv/content")

  def list(section) when section in ~w(projects notes publications) do
    section_path = Path.join(@root, section)

    section_path
    # Lists files in the directory, filters only .md files, and builds their full paths.
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".md"))
    |> Enum.map(&Path.join(section_path, &1))
    # Parses each markdown file into a map (using parse_md!/1)
    # Sorts them by date, descending, using Date module for proper date sorting.
    |> Enum.map(&parse_md!/1)
    |> Enum.sort_by(& &1.date, {:desc, Date})
    # At this point, you're getting a sorted list of content items (like blog posts, projects, etc.), each represented by a structured map.
  end



  # Loads a YAML file named now.yml from priv/content.
  # If it exists, parses it into Elixir data (using YamlElixir).
  # If it doesn’t exist, returns an empty list.
  def now() do
    path = Path.join(@root, "now.yml")
    case File.read(path) do
      {:ok, yml} -> YamlElixir.read_from_string!(yml)
      _ -> []
    end
  end

  ## internals
  # Convert Markdown + Frontmatter into a Map
  # This is the core function that transforms a plain .md file into a content object for the website.

# Reads the file contents
# Splits it into frontmatter (YAML metadata) and markdown body
# Parses markdown into HTML (via Earmark)
# Builds a structured Elixir map with keys like:
#   :title, :summary, :tags, :impact, :date, etc.
#   :slug: a URL-safe name based on the filename
#   :html: the rendered HTML of the markdown
  defp parse_md!(path) do
    body = File.read!(path)
    {meta, md} = split_frontmatter(body)
    html = Earmark.as_html!(md, code_class_prefix: "lang-")

    %{
      section: Path.basename(Path.dirname(path)),
      slug: path |> Path.basename(".md") |> slugify(),
      title: meta["title"] || "Untitled",
      summary: meta["summary"],
      tags: meta["tags"] || [],
      impact: meta["impact"],
      links: meta["links"] || %{},
      date: meta["date"] && Date.from_iso8601!(meta["date"]),
      html: html
    }
  end

  # Checks if the file starts with ---, which is how YAML frontmatter begins.
  # Splits the content into two parts:
  #   YAML frontmatter (for metadata)
  #   Markdown body
  # If no frontmatter is present, returns just the markdown with an empty metadata map.
  defp split_frontmatter(<<"---", rest::binary>>) do
    [yml, md] = String.split(rest, "\n---\n", parts: 2)
    {YamlElixir.read_from_string!(yml), md}
  end
  defp split_frontmatter(md), do: {%{}, md}

  # Create URL-Friendly Slugs
  #
  # Takes a filename like 2023-08-01-my-awesome-project.md
  # Removes the date
  # Converts to lowercase
  # Replaces spaces/special characters with -
  # Trims extra hyphens
  defp slugify(name) do
    name
    |> String.replace(~r/^\d{4}-\d{2}-\d{2}-/, "")
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/u, "-")
    |> String.trim("-")
  end

  # Fetch a single content item by slug within a given section.
  #
  # Used for detail pages like /notes/:slug or /projects/:slug.
  # Searches the list of parsed items in the section and returns the one with a matching slug.
  #
  # logic: “Find me the file in this section whose filename (after slugifying) matches this slug.”
  def get(section, slug) when section in ~w(projects notes publications) do
    list(section) |> Enum.find(&(&1.slug == slug))
  end
end
