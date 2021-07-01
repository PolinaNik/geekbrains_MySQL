CREATE DATABASE VK;
USE VK;

/* Таблица с пользователями */
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(11) UNIQUE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );


/* Профиль пользователя */
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birth_date DATE,
    user_id INT UNIQUE NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    profile_status ENUM('online', 'offline', 'inactive')
    
);

/* Добавление внешнего ключа для поля user_id*/
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);


/*Таблица с сообщениями*/
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    message_header VARCHAR(255),
    message_body TEXT NOT NULL,
    sent_flag INT NOT NULL,
    edited_flag INT NOT NULL,
    recieved_flag INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP
    
);

/*Добавление внешних ключей для полей from_user_id и to_user_id*/
ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);


/*Таблица с дружбой между пользователями*/
DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    friendship_status ENUM('friendship', 'following', 'blocked'),
    requested_at DATETIME NOT NULL,
    accepted_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP

);

/*Добавление внешних ключей для полей user_id и friend_id*/
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);


/*Таблица с сообществами*/
DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `name` VARCHAR(255) UNIQUE NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP

);


/*Таблица с пользователями, состоящих в сообществах*/
DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
    community_id INT NOT NULL,
    user_id INT NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (community_id, user_id)

);

/*Добавление внешних ключей для полей user_id и community_id*/
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_ommunity_id FOREIGN KEY (community_id) REFERENCES communities(id);


/*Таблица с аудио файлами*/
DROP TABLE IF EXISTS audio_files;
CREATE TABLE audio_files (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    content BLOB NOT NULL,
    likes INT default '0' NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

/*Добавление внешнего ключа для поля user_id*/
ALTER TABLE audio_files ADD CONSTRAINT fk_af_user_id FOREIGN KEY (user_id) REFERENCES users(id);


/*Таблица с видео файлами*/
DROP TABLE IF EXISTS video_files;
CREATE TABLE video_files (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    comment_message VARCHAR(1000) NOT NULL,
    content BLOB NOT NULL,
    likes INT default '0' NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP
    
);

/*Добавление внешнего ключа для поля user_id*/
ALTER TABLE video_files ADD CONSTRAINT fk_vf_user_id FOREIGN KEY (user_id) REFERENCES users(id);


/*Таблица с картинками*/
DROP TABLE IF EXISTS pictures;
CREATE TABLE pictures (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    comment_message VARCHAR(1000) NOT NULL,
    content BLOB NOT NULL,
    likes INT default '0' NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP
    
);

/*Добавление внешнего ключа для поля user_id*/
ALTER TABLE pictures ADD CONSTRAINT fk_pictures_user_id FOREIGN KEY (user_id) REFERENCES users(id);


/*Таблица с постами.
Суть в том, что пост может быть без медиафайлов, или наоборот без текста, но с медиафайлами.
Поэтому поле message_post может быть пустым.
Если в посте используются медиафайлы, то запись о них будет регистрироваться в отельной таблице
posts_files*/

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (

	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    message_post TEXT,
    likes INT default '0' NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatetd_at DATETIME DEFAULT CURRENT_TIMESTAMP
    
);

/*Добавление внешнего ключа для поля user_id*/
ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users(id);

/*Таблица с файлами для постов*/
DROP TABLE IF EXISTS posts_files;
CREATE TABLE posts_files (

	post_id INT NOT NULL,
    user_id INT NOT NULL,
    audio_file INT,
    video_file INT,
    picture INT,
    PRIMARY KEY (post_id, user_id)
    
);

/*Внешние ключи для полей user_id, post_id, audio_file, video_file, picture*/
ALTER TABLE posts_files ADD CONSTRAINT fk_pf_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts_files ADD CONSTRAINT fk_pf_post_id FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE posts_files ADD CONSTRAINT fk_pf_audio_file FOREIGN KEY (audio_file) REFERENCES audio_files(id);
ALTER TABLE posts_files ADD CONSTRAINT fk_pf_video_file FOREIGN KEY (video_file) REFERENCES video_files(id);
ALTER TABLE posts_files ADD CONSTRAINT fk_pf_picture FOREIGN KEY (picture) REFERENCES pictures(id);

