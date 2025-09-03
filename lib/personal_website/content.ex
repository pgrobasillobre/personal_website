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

  def list(section) when section in ~w(projects notes publications cases) do
    section_path = Path.join(@root, section)

    section_path
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".md"))
    |> Enum.map(&Path.join(section_path, &1))
    |> Enum.map(&parse_md!/1)
    |> Enum.sort_by(&sort_date_key/1, {:desc, Date})
  end

  defp sort_date_key(%{date: %Date{} = d}), do: d
  defp sort_date_key(_), do: ~D[0001-01-01]   # fallback for nil/absent dates


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

    html =
      md
      |> Earmark.as_html!(
        code_class_prefix: "lang-",
        gfm: true,
        smartypants: false
      )
      |> inject_heading_ids()

    %{
      section: Path.basename(Path.dirname(path)),
      slug: path |> Path.basename(".md") |> slugify(),
      title: meta["title"] || "Untitled",
      summary: meta["summary"],
      authors: meta["authors"] || [],
      tags: meta["tags"] || [],
      impact: meta["impact"],
      links: meta["links"] || %{},
      image: meta["image"],
      abstract: meta["abstract"],
      venue: meta["venue"] || nil,
      date: meta["date"] && Date.from_iso8601!(meta["date"]),
      html: html
    }
  end



  defp inject_heading_ids(html) do
    {:ok, doc} = Floki.parse_document(html)

    doc =
      Floki.traverse_and_update(doc, fn
        {"h2", attrs, children} ->
          text = Floki.text(children) |> String.trim()
          {"h2", put_id(attrs, slugify(text)), children}
        {"h3", attrs, children} ->
          text = Floki.text(children) |> String.trim()
          {"h3", put_id(attrs, slugify(text)), children}
        other -> other
      end)

    Floki.raw_html(doc)
  end

  defp put_id(attrs, id) do
    if Enum.any?(attrs, fn {k, _} -> k == "id" end) do
      attrs
    else
      [{"id", id} | attrs]
    end
  end

  # Checks if the file starts with ---, which is how YAML frontmatter begins.
  # Splits the content into two parts:
  #   YAML frontmatter (for metadata)
  #   Markdown body
  # If no frontmatter is present, returns just the markdown with an empty metadata map.
  defp split_frontmatter(str) when is_binary(str) do
    raw = strip_bom(str)

    # Match:
    #   ---\n<yaml>\n---\n<body...>   (POSIX)
    #   ---\r\n<yaml>\r\n---\r\n<body> (Windows)
    #   also tolerates optional spaces after closing --- and optional blank line before body
    regex = ~r/
      \A---\s*\r?\n               # opening ---
      (?<yml>.*?)                 # YAML front-matter (non-greedy)
      \r?\n---\s*\r?\n?           # closing ---
      (?<md>.*)\z                 # rest is markdown body (possibly empty)
    /msx

    case Regex.named_captures(regex, raw) do
      %{"yml" => yml, "md" => md} ->
        {YamlElixir.read_from_string!(String.trim_trailing(yml)), md}

      _ ->
        # No (valid) front-matter; treat whole file as markdown
        {%{}, raw}
    end
  end

  defp strip_bom(<<239, 187, 191, rest::binary>>), do: rest
  defp strip_bom(other), do: other

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
