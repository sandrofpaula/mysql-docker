Para conectar seus contêineres Docker `mysql_dev`, `giiwizard-beta`, e `giiwizard` para que eles possam se comunicar entre si, utilizando uma rede Docker compartilhada. Vou guiar você passo a passo em português.

### Passos para Conectar Contêineres Existentes a uma Rede Compartilhada

#### 1. **Criar uma Rede Docker Compartilhada**

Primeiro, você precisa criar uma rede Docker onde todos os contêineres que precisam se comunicar serão conectados. Vamos criar uma rede chamada `minha_rede_compartilhada`:

```bash
docker network create minha_rede_compartilhada
```

Esse comando cria uma rede Docker chamada `minha_rede_compartilhada`. Qualquer contêiner que for conectado a essa rede poderá se comunicar com os outros contêineres na mesma rede.

#### 2. **Conectar os Contêineres à Rede Compartilhada**

Agora, vamos conectar cada um dos contêineres existentes (`mysql_dev`, `giiwizard-beta`, e `giiwizard`) à rede `minha_rede_compartilhada`.

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

Agora que os contêineres estão na mesma rede, precisamos ajustar a configuração da conexão ao banco de dados no Yii2, tanto no `giiwizard-beta` quanto no `giiwizard`, para que eles usem o contêiner `mysql_dev` como o servidor MySQL.

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

Com esses passos, os contêineres `giiwizard-beta` e `giiwizard` poderão se conectar ao banco de dados MySQL rodando no contêiner `mysql_dev`. Agora eles podem se comunicar entre si sem problemas!



Para listar todas as redes Docker existentes no seu ambiente, você pode usar o seguinte comando:

```bash
docker network ls
```

Esse comando exibirá uma lista de todas as redes Docker disponíveis, incluindo redes padrão e qualquer rede personalizada que você tenha criado.

### Exemplo de Saída

Após executar `docker network ls`, você verá algo parecido com isto:

```bash
NETWORK ID     NAME                            DRIVER    SCOPE
1e5ef326ed0d   bridge                          bridge    local
5625c49780dd   minha_rede_compartilhada        bridge    local
847ca6374f70   host                            host      local
9b31797cb726   none                            null      local
```

- **NETWORK ID**: O identificador único da rede.
- **NAME**: O nome da rede.
- **DRIVER**: O driver de rede, como `bridge`, `host`, ou `null`.
- **SCOPE**: O escopo da rede, normalmente `local`.

### Redes Padrão:

- **bridge**: Rede padrão onde contêineres são colocados se nenhuma outra rede for especificada.
- **host**: Remove o isolamento de rede entre o contêiner e o host.
- **none**: Desativa o networking para o contêiner, criando apenas a interface de loopback.

Isso deve ajudar a identificar e gerenciar as redes Docker no seu ambiente. Se precisar de mais alguma coisa, é só avisar!