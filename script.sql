CREATE SCHEMA IF NOT EXISTS regina_pratas_db DEFAULT CHARACTER SET utf8mb4;
USE regina_pratas_db;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(200) NOT NULL,
  `email` VARCHAR(200) NOT NULL,
  `senha` VARCHAR(200) NOT NULL,
  `celular` TEXT,
  `sobre` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `produto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `descricao` TEXT NOT NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  `imagem` TEXT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `categoria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome_categoria` VARCHAR(255) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuario_id` INT NOT NULL,
  `id_transacao` TEXT NULL,
  `cpf_cliente` VARCHAR(45) NULL,
  `endereco_entrega` TEXT NOT NULL,
  `status_pedido` VARCHAR(20) NOT NULL DEFAULT 'pendente',
  `data_criacao` DATETIME NULL,
  `data_expiracao` DATETIME NULL,
  PRIMARY KEY (id),
  INDEX `fk_pedido_usuario_idx` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuario` (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pedido_item` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quantidade` VARCHAR(45) NOT NULL,
  `pedido_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  PRIMARY KEY (id),
  INDEX `fk_pedido_produto_pedido1_idx` (`pedido_id` ASC) VISIBLE,
  INDEX `fk_pedido_produto_produto1_idx` (`produto_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_produto_pedido1`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `pedido` (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_produto_produto1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `produto` (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;