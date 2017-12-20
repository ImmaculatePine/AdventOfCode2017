defmodule Day20.Particle do
  @max_iterations 50_000

  @doc """
      iex> Day20.Particle.parse("p=<-11104,1791,5208>, v=<-6,36,-84>, a=<19,-5,-4>")
      {{-11104, 1791, 5208}, {-6, 36, -84}, {19, -5, -4}}
  """
  def parse(input) when is_binary(input) do
    ~r/p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/
      |> Regex.run(input)
      |> parse
  end

  def parse([_ | coordinates]) do
    coordinates
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(3)
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple
  end

  def closest(particles) do
    closest(particles, @max_iterations)
  end

  defp closest(particles, 0) do
    min = Enum.min_by(particles, &distance/1)
    Enum.find_index(particles, &(&1 == min))
  end

  defp closest(particles, n) do
    particles
      |> Enum.map(&update/1)
      |> closest(n - 1)
  end

  def remove_collisions(particles) do
    remove_collisions(particles, @max_iterations)
  end

  defp remove_collisions(particles, 0) do
    particles
  end

  defp remove_collisions(particles, iterations_left) do
    particles
      |> Enum.map(&update/1)
      |> collide
      |> remove_collisions(iterations_left - 1)
  end

  @doc """
      iex> [{{0, 0, 0}, {3,0,0}, {0,0,0}}, {{0, 0, 0}, {2,0,0}, {0,0,0}}, {{0, 0, 0}, {1,0,0}, {0,0,0}}, {{1, 0, 0}, {-1,0,0}, {0,0,0}}] |>
      iex> Day20.Particle.collide
      [{{1, 0, 0}, {-1,0,0}, {0,0,0}}]
  """
  def collide(particles) do
    particles
      |> Enum.group_by(fn {pos, _, _} -> pos end)
      |> Enum.reject(fn {_, list} -> length(list) > 1 end)
      |> Enum.map(fn {_, [particle]} -> particle end)
  end

  @doc """
      iex> Day20.Particle.update({{3, 0, 0}, {2, 0, 0}, {-1, 0, 0}})
      {{4, 0, 0}, {1, 0, 0}, {-1, 0, 0}}
  """
  def update({{px, py, pz}, {vx, vy, vz}, a = {ax, ay, az}}) do
    {
      {px + vx + ax, py + vy + ay, pz + vz + az},
      {vx + ax, vy + ay, vz + az},
      a
    }
  end

  @doc """
      iex> Day20.Particle.distance({{3, 0, 0}, {2, 0, 0}, {-1, 0, 0}})
      3
  """
  def distance({{x, y, z}, _, _}) do
    abs(x) + abs(y) + abs(z)
  end
end
