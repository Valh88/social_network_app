# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SocialNetworkApp.Repo.insert!(%SocialNetworkApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias SocialNetworkApp.Roles
for role <- Roles.default_roles() do
  IO.inspect(Roles.get_role_by_name(role[:name]))
  unless Roles.get_role_by_name(role[:name]) do
    {:ok, _role} = Roles.create_role(role)
  end
end
