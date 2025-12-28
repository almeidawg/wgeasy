# GUIA DE FERRAMENTAS PARA PRODUCAO DO VIDEO

## OPCAO 1: GRAVAR A APRESENTACAO HTML (Mais Facil)

### Passo a Passo:

1. **Abra o arquivo** `02-APRESENTACAO-ANIMADA.html` no navegador
2. **Pressione F11** para tela cheia
3. **Inicie a gravacao** com uma das ferramentas abaixo
4. **Pressione ESPACO** ou aguarde a transicao automatica
5. **Pare a gravacao** apos o ultimo slide

### Ferramentas de Gravacao de Tela (Gratuitas):

#### OBS Studio (Recomendado)
- **Download:** https://obsproject.com/
- **Vantagens:** Profissional, gratuito, sem marca d'agua
- **Configuracao:**
  1. Sources > + > Window Capture > Selecione o navegador
  2. Settings > Output > Recording Format: mp4
  3. Settings > Video > 1920x1080, 60fps
  4. Clique em "Start Recording"

#### Xbox Game Bar (Windows 10/11)
- **Atalho:** Windows + G
- **Gravacao:** Windows + Alt + R
- **Vantagens:** Ja vem instalado no Windows

#### Loom
- **Site:** https://www.loom.com/
- **Vantagens:** Facil de usar, gravacao instantanea
- **Limite gratuito:** 5 minutos por video

#### ShareX
- **Download:** https://getsharex.com/
- **Vantagens:** Muitas opcoes, GIF e video

---

## OPCAO 2: CAPTURAR SCREENSHOTS DO SISTEMA REAL

### Ferramentas de Screenshot:

#### Snipping Tool (Windows)
- **Atalho:** Windows + Shift + S
- **Selecione** a area desejada

#### Lightshot
- **Download:** https://app.prntscr.com/
- **Atalho:** Print Screen
- **Vantagens:** Edicao rapida

#### Greenshot
- **Download:** https://getgreenshot.org/
- **Vantagens:** Captura de tela rolavel

### Telas para Capturar:

| Ordem | Tela | Rota | Descricao |
|-------|------|------|-----------|
| 1 | Dashboard | `/` | Visao geral com KPIs |
| 2 | Clientes | `/pessoas/clientes` | Lista de clientes |
| 3 | Painel Cliente | `/pessoas/clientes/:id` | Detalhes do cliente |
| 4 | Oportunidades | `/oportunidades` | Kanban comercial |
| 5 | Propostas | `/propostas` | Lista de propostas |
| 6 | Contratos | `/contratos` | Lista de contratos |
| 7 | Kanban Arquitetura | `/oportunidades/kanban/arquitetura` | Nucleo verde |
| 8 | Kanban Engenharia | `/oportunidades/kanban/engenharia` | Nucleo azul |
| 9 | Kanban Marcenaria | `/oportunidades/kanban/marcenaria` | Nucleo marrom |
| 10 | Financeiro | `/financeiro` | Dashboard financeiro |
| 11 | Cronograma | `/cronograma` | Visao geral projetos |
| 12 | Timeline | `/cronograma/timeline` | Grafico de Gantt |

### Dicas para Screenshots Profissionais:

1. **Resolucao:** Use 1920x1080 ou superior
2. **Zoom:** 100% no navegador (Ctrl + 0)
3. **Dados:** Preencha com dados de exemplo realistas
4. **Limpeza:** Feche abas desnecessarias
5. **Cursor:** Esconda o cursor se possivel

---

## OPCAO 3: EDICAO DE VIDEO

### Editores Gratuitos:

#### DaVinci Resolve (Recomendado)
- **Download:** https://www.blackmagicdesign.com/products/davinciresolve
- **Vantagens:** Profissional, completo, gratuito
- **Curva de aprendizado:** Media

#### CapCut (Desktop)
- **Download:** https://www.capcut.com/
- **Vantagens:** Facil, muitos efeitos, gratuito
- **Ideal para:** Videos rapidos

#### Clipchamp (Microsoft)
- **Acesso:** Ja vem no Windows 11 ou via web
- **Vantagens:** Integrado, simples

#### Canva Video
- **Site:** https://www.canva.com/
- **Vantagens:** Templates prontos, facil
- **Limite gratuito:** Recursos basicos

### Workflow de Edicao:

```
1. Importar midia (screenshots/gravacao)
         |
         v
2. Organizar na timeline
         |
         v
3. Adicionar transicoes (fade, slide)
         |
         v
4. Inserir texto/legendas
         |
         v
5. Adicionar trilha sonora
         |
         v
6. Ajustar timing conforme roteiro
         |
         v
7. Exportar em MP4 (H.264)
```

---

## TRILHA SONORA (Royalty-Free)

### Bibliotecas Gratuitas:

| Biblioteca | Link | Estilo |
|------------|------|--------|
| YouTube Audio Library | studio.youtube.com | Variado |
| Pixabay Music | pixabay.com/music | Corporativo |
| Mixkit | mixkit.co/free-stock-music | Moderno |
| Free Music Archive | freemusicarchive.org | Artistico |
| Uppbeat | uppbeat.io | Trending |

### Sugestoes de Busca:
- "Corporate uplifting"
- "Technology modern"
- "Business inspiration"
- "Minimal corporate"

---

## NARRACAO (Opcional)

### Opcao 1: Gravar Voz
- Use o microfone do computador/celular
- Ambiente silencioso
- Fale devagar e claro

### Opcao 2: Texto na Tela
- A apresentacao HTML ja tem textos
- Adicione legendas no editor

### Opcao 3: IA Text-to-Speech
- **ElevenLabs:** https://elevenlabs.io/ (voz realista)
- **Murf AI:** https://murf.ai/
- **Play.ht:** https://play.ht/

---

## EXPORTACAO FINAL

### Configuracoes Recomendadas:

| Parametro | Valor |
|-----------|-------|
| Formato | MP4 (H.264) |
| Resolucao | 1920x1080 (Full HD) |
| Frame Rate | 30 fps |
| Bitrate | 8-12 Mbps |
| Audio | AAC, 192 kbps |

### Plataformas de Destino:

| Plataforma | Formato | Limite |
|------------|---------|--------|
| YouTube | MP4 | 15 min (nao verificado) |
| LinkedIn | MP4 | 10 min, 5 GB |
| Instagram | MP4 | 60 seg (feed), 90 seg (reels) |
| WhatsApp | MP4 | 16 MB |
| Site | MP4 | Depende da hospedagem |

---

## CHECKLIST FINAL

- [ ] Gravacao/screenshots capturados
- [ ] Video editado seguindo o roteiro
- [ ] Transicoes suaves entre cenas
- [ ] Trilha sonora adicionada
- [ ] Volume da musica ajustado
- [ ] Duracao entre 1:00 e 1:30
- [ ] Exportado em Full HD
- [ ] Revisado por outra pessoa
- [ ] Backup do projeto salvo
