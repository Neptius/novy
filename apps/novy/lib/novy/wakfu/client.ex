defmodule Novy.Wakfu.Client do
  @moduledoc """
  The Wakfu client.
  """

  @doc """
  Fetches the specified type of data from the Wakfu CDN.

  ## Parameters
    * `type` - The type of data to fetch.
      - `actions` : contient les descriptions des types d'effets (perte de PdV, boost de PA, etc)
      - `blueprints` : contient la liste des plans débloquant des recettes
      - `collectibleResources` : contient les actions de récolte
      - `equipmentItemTypes` : contient les définitions des types d'équipements et des emplacements associés
      - `harvestLoots` : contient les objets récupérés via la récolte
      - `itemTypes` : contient les définitions des types d'objets
      - `itemProperties` : contient les propriétés qui peuvent être appliquées à des objets
      - `items` : contient les données relatives aux items, leurs effets, nom, description, etc.. À croiser avec les données actions, equipmentItemTypes et itemProperties.
      - `jobsItems` : contient les données relatives aux items récoltés, craftés et utilisés par les recettes de craft (version light du items.json)
      - `recipeCategories` : contient la liste des métiers
      - `recipeIngredients` : contient les ingrédients des crafts
      - `recipeResults` : contient les objets produits par les crafts
      - `recipes` : contient la liste des recettes
      - `resourceTypes` : contient les types de ressources
      - `resources` : contient les ressources
      - `states` : contient les traduction des états utilisés par les équipements

  ## Examples
      iex> Novy.Wakfu.Client.get("items")
      {:ok, %{}}
  """
  @spec get(String.t()) :: {:ok, String.t()} | {:error, atom()}
  def get(type) do
    with {:ok, version} <- get_version(),
         url <- build_url(version, type),
         {:ok, %Req.Response{status: 200, body: datas}} <- Req.get(url) do
      {:ok, datas}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec get_version() :: {:ok, String.t()} | {:error, atom()}
  defp get_version do
    with {:ok, %Req.Response{status: 200, body: %{"version" => version}}} <-
           Req.get("https://wakfu.cdn.ankama.com/gamedata/config.json") do
      {:ok, version}
    else
      {:ok, %Req.Response{status: 404}} -> {:error, :not_found}
      {:error, _} -> {:error, :internal_server_error}
    end
  end

  @spec build_url(String.t(), String.t()) :: String.t()
  defp build_url(version, type) do
    "https://wakfu.cdn.ankama.com/gamedata/#{version}/#{type}.json"
  end
end
