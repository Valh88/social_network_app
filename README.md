# SocialNetworkApp

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Проект: 
Постим картинки. Класическое рест апи в Phoenix.
Содержит:
1. авторизацию, аутентификацию пользователя с Guardian библиотекой
2. систему разрешений и ролей: Пользователь может выполнять действия согласно его роли
3. поддерживать и отображать публикацию фотографий пользователя
4. добавления комментарий к фото
5. рейтинг фото и комментариям
6. возможность подписаться на автора и вывести подписки, только на подписанных авторов. 