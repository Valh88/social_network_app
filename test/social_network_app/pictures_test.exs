defmodule SocialNetworkApp.PicturesTest do
  alias SocialNetworkApp.Users
  use SocialNetworkApp.DataCase

  setup_all  do
    %{
      picture: %{name: "Name", path: "test/media/Name"},
      user_params: %{email: "test@email.ru", password_hash: "test_password"}
    }
  end

  describe "pictures" do
    import SocialNetworkApp.AccountsFixtures

    test "go pictures save in db", context do
      {:ok, picture} = SocialNetworkApp.Pictures.save_picture(context.picture)
      assert picture.name == "Name"
    end

    test "save all assoc user - picture", context do
      params = %{email: "test@email.ru", password_hash: "test_password"}
      user = create_account_user_fixture(context.user_params)
      assert Users.get_user_by_id(user.account_id)

      {:ok, %SocialNetworkApp.Pictures.PictureUserAssoc{} = assoc_picture} =
        SocialNetworkApp.Pictures.save_all_to_picture(user, context.picture)

      user = SocialNetworkApp.Repo.preload(user, :pictures)
      picture = SocialNetworkApp.Pictures.get_picture_by_id(assoc_picture.picture_id)
      assert assoc_picture.user_id == user.id
      assert [picture] == user.pictures
    end

    test "add comment", context do
      user = create_account_user_fixture(context.user_params)
      {:ok, picture} = SocialNetworkApp.Pictures.save_all_to_picture(user, context.picture)
      assert picture
      picture_params = %{picture_id: picture.id, user_id: user.id, text: "test comment save"}
      {:ok, comment} = SocialNetworkApp.Comments.create_comment(picture_params)
    end

    test "add raiting from user to picture", context do
      raiting_exemple = 4.554324234
      user = create_account_user_fixture(context.user_params)
      {:ok, picture} = SocialNetworkApp.Pictures.save_all_to_picture(user, context.picture)
      {:ok, raiting} = SocialNetworkApp.Pictures.add_raiting_from_user_to_picture(picture, user, raiting_exemple)
      assert raiting.picture_id == picture.id
      assert raiting.user_id == user.id
    end
  end
end
