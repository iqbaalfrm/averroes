--Credentials: test@averroes.web.id / password123

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  new_userId uuid := gen_random_uuid();
BEGIN
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'test@averroes.web.id') THEN
    
    INSERT INTO auth.users (
      id,
      instance_id,
      aud,
      role,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at,
      is_sso_user
    ) VALUES (
      new_userId,
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'test@averroes.web.id',
      crypt('password123', gen_salt('bf')), -- Password: password123
      now(), -- Auto confirm email
      '{"provider": "email", "providers": ["email"]}',
      '{"username": "Averroes Tester"}',
      now(),
      now(),
      false
    );

    RAISE NOTICE 'Test User Created successfully.';
    RAISE NOTICE 'Email: test@averroes.web.id';
    RAISE NOTICE 'Password: password123';

  ELSE
    RAISE NOTICE 'User test@averroes.web.id already exists.';
  END IF;
END $$;
