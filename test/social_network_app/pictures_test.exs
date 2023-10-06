defmodule SocialNetworkApp.PicturesTest do
  alias SocialNetworkApp.Users
  use SocialNetworkApp.DataCase

  setup_all  do
    %{name: "Name", path: "test/media/Name"}
  end

  describe "pictures" do
    alias SocialNetworkApp.Accounts
    import SocialNetworkApp.AccountsFixtures

    test "go pictures save in db", context do
      {:ok, picture} = SocialNetworkApp.Pictures.save_picture(context)
      assert picture.name == "Name"
    end

    test "save all assoc user - picture", context do
      user = create_account_user_fixture()
      assert Users.get_user_by_id(user.account_id)

      {:ok, %SocialNetworkApp.Pictures.PictureUserAssoc{} = assoc_picture} =
        SocialNetworkApp.Pictures.save_all_to_picture(user, context)

      user = SocialNetworkApp.Repo.preload(user, :pictures)
      picture = SocialNetworkApp.Pictures.get_picture_by_id(assoc_picture.picture_id)
      assert assoc_picture.user_id == user.id
      assert [picture] == user.pictures
    end
  end
end
