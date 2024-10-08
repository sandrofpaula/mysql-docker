## Conectando Contêineres Docker para Comunicação entre si

Para conectar seus contêineres Docker `mysql_dev`, `sistema_alpha`, e `sistema_beta` para que eles possam se comunicar entre si, utilizaremos uma rede Docker compartilhada. Vou guiar você passo a passo.

### Passos para Conectar Contêineres Existentes a uma Rede Compartilhada

#### 1. **Criar uma Rede Docker Compartilhada**

Primeiro, crie uma rede Docker onde todos os contêineres que precisam se comunicar serão conectados. Vamos criar uma rede chamada `minha_rede_compartilhada`:

```bash
docker network create minha_rede_compartilhada
```

Esse comando cria uma rede Docker chamada `minha_rede_compartilhada`. Qualquer contêiner conectado a essa rede poderá se comunicar com os outros contêineres na mesma rede.

#### 2. **Conectar os Contêineres à Rede Compartilhada**

Agora, conecte cada um dos contêineres existentes (`mysql_dev`, `sistema_alpha`, e `sistema_beta`) à rede `minha_rede_compartilhada`.

- **Conecte o contêiner `mysql_dev` à rede `minha_rede_compartilhada`**:

   ```bash
   docker network connect minha_rede_compartilhada mysql_dev
   ```

- **Conecte o contêiner `sistema_alpha` à rede `minha_rede_compartilhada`**:

   ```bash
   docker network connect minha_rede_compartilhada sistema_alpha
   ```

- **Conecte o contêiner `sistema_beta` à rede `minha_rede_compartilhada`**:

   ```bash
   docker network connect minha_rede_compartilhada sistema_beta
   ```

Com isso, todos os contêineres agora fazem parte da mesma rede `minha_rede_compartilhada` e podem se comunicar entre si.

### 3. **Verificar Contêineres Conectados à Rede**

Depois de conectar os contêineres à rede, você pode querer verificar quais contêineres estão realmente conectados à `minha_rede_compartilhada`. Para isso, use o seguinte comando:

```bash
docker network inspect minha_rede_compartilhada
```

Este comando retorna informações detalhadas sobre a rede, incluindo uma seção chamada `Containers`, que lista todos os contêineres conectados a ela.

#### Exemplo de Saída:

```json
[
    {
        "Name": "minha_rede_compartilhada",
        "Id": "1e5ef326ed0d...",
        "Created": "2024-08-17T00:00:00.000000000Z",
        "Scope": "local",
        "Driver": "bridge",
        "Containers": {
            "c3a2d6e6f7f9": {
                "Name": "mysql_dev",
                "EndpointID": "3a3f2f5b...",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "b6c831102717": {
                "Name": "sistema_alpha",
                "EndpointID": "ab1f8c9a...",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            }
        }
    }
]
```

- **Containers**: Esta seção lista todos os contêineres conectados à rede.
  - **Name**: O nome do contêiner.
  - **IPv4Address**: O endereço IP atribuído ao contêiner na rede.

Com essas informações, você pode garantir que os contêineres que você conectou estão realmente na rede e prontos para se comunicar.

### 4. **Configurar o Yii2 para Conectar ao MySQL**

Agora que os contêineres estão na mesma rede, precisamos ajustar a configuração da conexão ao banco de dados no Yii2, tanto no `sistema_alpha` quanto no `sistema_beta`, para que eles usem o contêiner `mysql_dev` como servidor MySQL.

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
2. **Conecte os contêineres `mysql_dev`, `sistema_alpha`, e `sistema_beta` à rede**:
   - `docker network connect minha_rede_compartilhada mysql_dev`
   - `docker network connect minha_rede_compartilhada sistema_alpha`
   - `docker network connect minha_rede_compartilhada sistema_beta`
3. **Verifique quais contêineres estão conectados**: `docker network inspect minha_rede_compartilhada`.
4. **Configure o Yii2 para usar o host `mysql_dev`** no `dsn` para se conectar ao banco de dados MySQL.

Com esses passos, os contêineres `sistema_alpha` e `sistema_beta` poderão se conectar ao banco de dados MySQL rodando no contêiner `mysql_dev`, permitindo que eles se comuniquem sem problemas!

### Listar Todas as Redes Docker Existentes

Para listar todas as redes Docker existentes no seu ambiente, utilize o comando:

```bash
docker network ls
```

Este comando exibirá uma lista de todas as redes Docker, incluindo as redes padrão e quaisquer redes personalizadas que você tenha criado.

### Como Apagar uma Rede Docker

Para apagar uma rede Docker, você pode usar o comando `docker network rm`. Esse comando permite que você remova uma rede específica.

### Comando para Apagar uma Rede Docker

```bash
docker network rm <nome_da_rede>
```

Substitua `<nome_da_rede>` pelo nome da rede que você deseja apagar.

### Observações:

- Você não pode remover uma rede que está sendo usada por contêineres. Se houver contêineres conectados à rede, você precisará primeiro desconectá-los ou parar esses contêineres antes de remover a rede.
- Para desconectar um contêiner de uma rede, use:

  ```bash
  docker network disconnect <nome_da_rede> <nome_do_container>
  ```

  Exemplo:

  ```bash
  docker network disconnect minha_rede_compartilhada sistema_alpha
  ```

Depois de remover a rede, ela não estará mais disponível para conexão de contêineres. Se precisar de mais ajuda ou informações, estou à disposição!

### Para descobrir a qual network um container pertence no Docker

Para descobrir a qual network um container pertence no Docker, você pode usar o comando `docker inspect`. Aqui estão as etapas para verificar essa informação:

1. **Listar os containers em execução:**

   ```bash
   docker ps
   ```

   Isso listará todos os containers em execução com seus IDs e nomes.

2. **Inspecionar um container específico para ver as networks associadas:**

   ```bash
   docker inspect <container_id_or_name>
   ```

   Substitua `<container_id_or_name>` pelo ID ou nome do container que você deseja inspecionar.

3. **Filtrar apenas as informações da network:**

   Para extrair apenas as informações relacionadas à network, você pode usar `grep` ou `jq`. Por exemplo:

   ```bash
   docker inspect <container_id_or_name> | grep -i "network"
   ```

   Ou, se você tiver o `jq` instalado:

   ```bash
   docker inspect <container_id_or_name> | jq '.[0].NetworkSettings.Networks'
   ```

   Isso mostrará as networks às quais o container está conectado, bem como o nome das networks.

Se você quiser ver uma visão geral de todos os containers conectados a uma network específica, pode usar:

```bash
docker network inspect <network_name>
```

### Ajustar o mapeamento de portas de um contêiner Docker

Você pode ajustar o mapeamento de portas de um contêiner Docker existente sem precisar apagar e recriar o contêiner, mas isso envolve alguns passos manuais, pois o Docker não permite diretamente remapear as portas de um contêiner já criado.

Aqui está o processo que você pode seguir:

1. **Pare o contêiner existente:**

   Primeiro, pare o contêiner MySQL existente:

   ```bash
   docker stop mysql_dev
   ```

2. **Renomeie ou remova o contêiner existente (opcional):**

   Para evitar conflitos, você pode renomear o contêiner existente ou removê-lo (apenas o contêiner, não os dados):

   **Renomear:**
   ```bash
   docker rename mysql_dev mysql_dev_old
   ```

   **Remover o contêiner (mantendo os dados no volume):**
   ```bash
   docker rm mysql_dev
   ```

3.

 **Inicie um novo contêiner com a nova configuração de porta:**

   Use o comando abaixo para iniciar um novo contêiner usando a nova configuração de portas:

   ```bash
   docker run -d --name mysql_dev -p 37:3306 \
   -e MYSQL_ROOT_PASSWORD='suaSenhaSegura' \
   -v mysql_data:/var/lib/mysql \
   mysql:8.0
   ```

   - **`-p 37:3306`**: Mapeia a porta 37 no host para a porta 3306 no contêiner.
   - **`-v mysql_data:/var/lib/mysql`**: Monta o volume de dados existente para garantir que seus dados MySQL não sejam perdidos.
   - **`--name mysql_dev`**: Nomeia o novo contêiner como `mysql_dev`.

4. **Verifique se o contêiner está em execução:**

   Confirme que o novo contêiner está em execução e que a porta foi mapeada corretamente:

   ```bash
   docker ps
   ```

   Isso deve mostrar o contêiner `mysql_dev` com a porta 37 mapeada para 3306.

### Alternativa: Docker Compose

Se você está usando `docker-compose`, apenas atualize o arquivo `docker-compose.yml` com a nova configuração:

```yaml
ports:
  - "37:3306"
```

Depois, aplique as mudanças sem recriar os volumes:

```bash
docker-compose up -d --force-recreate --no-deps mysql
```

Isso recriará o contêiner `mysql` com a nova configuração de portas, mantendo os dados intactos.