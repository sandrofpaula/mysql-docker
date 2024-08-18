## Conectando Contêineres Docker para Comunicação entre si

Para conectar seus contêineres Docker `mysql_dev`, `giiwizard-beta`, e `giiwizard` para que eles possam se comunicar entre si, utilizaremos uma rede Docker compartilhada. Vou guiar você passo a passo.

### Passos para Conectar Contêineres Existentes a uma Rede Compartilhada

#### 1. **Criar uma Rede Docker Compartilhada**

Primeiro, crie uma rede Docker onde todos os contêineres que precisam se comunicar serão conectados. Vamos criar uma rede chamada `minha_rede_compartilhada`:

```bash
docker network create minha_rede_compartilhada
```

Esse comando cria uma rede Docker chamada `minha_rede_compartilhada`. Qualquer contêiner conectado a essa rede poderá se comunicar com os outros contêineres na mesma rede.

#### 2. **Conectar os Contêineres à Rede Compartilhada**

Agora, conecte cada um dos contêineres existentes (`mysql_dev`, `giiwizard-beta`, e `giiwizard`) à rede `minha_rede_compartilhada`.

- **Conecte o contêiner `mysql_dev` à rede `minha_rede_compartilhada`**:

   ```bash
   docker network connect minha_rede_compartilhada mysql_dev
   ```

- **Conecte o contêiner `giiwizard-beta` à rede `minha_rede_compartilhada`**:

   ```bash
   docker network connect minha_rede_compartilhada giiwizard-beta
   ```

- **Conecte o contêiner `giiwizard` à rede `minha_rede_compartilhada`**:

   ```bash
   docker network connect minha_rede_compartilhada giiwizard
   ```

Com isso, todos os contêineres agora fazem parte da mesma rede `minha_rede_compartilhada` e podem se comunicar entre si.

#### 3. **Configurar o Yii2 para Conectar ao MySQL**

Agora que os contêineres estão na mesma rede, precisamos ajustar a configuração da conexão ao banco de dados no Yii2, tanto no `giiwizard-beta` quanto no `giiwizard`, para que eles usem o contêiner `mysql_dev` como servidor MySQL.

No arquivo de configuração do Yii2 (`config/db.php`), atualize o `dsn` para usar `mysql_dev` como o host:

```php
return [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=mysql_dev;dbname=biblioteca',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8',
    'tablePrefix' => 'tb_',
];
```

### Resumo Final:

1. **Crie a rede Docker compartilhada**: `docker network create minha_rede_compartilhada`.
2. **Conecte os contêineres `mysql_dev`, `giiwizard-beta`, e `giiwizard` à rede**:
   - `docker network connect minha_rede_compartilhada mysql_dev`
   - `docker network connect minha_rede_compartilhada giiwizard-beta`
   - `docker network connect minha_rede_compartilhada giiwizard`
3. **Configure o Yii2 para usar o host `mysql_dev`** no `dsn` para se conectar ao banco de dados MySQL.

Com esses passos, os contêineres `giiwizard-beta` e `giiwizard` poderão se conectar ao banco de dados MySQL rodando no contêiner `mysql_dev`, permitindo que eles se comuniquem sem problemas!

---

### Listar Todas as Redes Docker Existentes

Para listar todas as redes Docker existentes no seu ambiente, utilize o comando:

```bash
docker network ls
```

Este comando exibirá uma lista de todas as redes Docker, incluindo as redes padrão e quaisquer redes personalizadas que você tenha criado.

### Como Funciona:

- **`docker network ls`**: Lista todas as redes Docker disponíveis no sistema.

### Exemplo de Saída:

Após executar o comando, você verá uma lista parecida com esta:

```bash
NETWORK ID     NAME                            DRIVER    SCOPE
1e5ef326ed0d   bridge                          bridge    local
5625c49780dd   minha_rede_compartilhada        bridge    local
847ca6374f70   host                            host      local
9b31797cb726   none                            null      local
```

- **NETWORK ID**: O identificador único da rede.
- **NAME**: O nome da rede.
- **DRIVER**: O driver de rede (por exemplo, `bridge`, `host`, `null`).
- **SCOPE**: O escopo da rede (normalmente `local`).

Esse comando é útil para verificar as redes disponíveis e gerenciar a conectividade entre seus contêineres Docker.

---

### Como Apagar uma Rede Docker

Para apagar uma rede Docker, você pode usar o comando `docker network rm`. Esse comando permite que você remova uma rede específica.

### Comando para Apagar uma Rede Docker

```bash
docker network rm <nome_da_rede>
```

Substitua `<nome_da_rede>` pelo nome da rede que você deseja apagar.

### Passos:

1. **Liste as redes Docker para encontrar o nome da rede que deseja apagar**:

   ```bash
   docker network ls
   ```

2. **Apague a rede**:

   Por exemplo, se você quiser apagar a rede `minha_rede_compartilhada`:

   ```bash
   docker network rm minha_rede_compartilhada
   ```

### Observações:

- Você não pode remover uma rede que está sendo usada por contêineres. Se houver contêineres conectados à rede, você precisará primeiro desconectar ou parar esses contêineres antes de remover a rede.
- Para desconectar um contêiner de uma rede, use:

  ```bash
  docker network disconnect <nome_da_rede> <nome_do_container>
  ```

  Exemplo:

  ```bash
  docker network disconnect minha_rede_compartilhada giiwizard-beta
  ```

Depois de remover a rede, ela não estará mais disponível para conexão de contêineres.

Se precisar de mais ajuda ou informações, estou à disposição!