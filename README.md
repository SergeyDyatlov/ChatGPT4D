# ChatGPT4D

TChatGPT - предназначен для общения с API OpenAI GPT-3. Он использует библиотеки IdHTTP и IdSSLOpenSSL для создания HTTP запросов и обработки ответов сервера. Класс позволяет отправлять запросы на генерацию текста и получать ответ в виде строки.

Для отправки запроса на получение ответа используется метод Ask, который принимает строку с вопросом. Полученный ответ можно получить через свойство Response. Также есть возможность назначить событие OnResponse, которое будет вызвано после того, как ответ будет получен.

https://beta.openai.com/account/api-keys
