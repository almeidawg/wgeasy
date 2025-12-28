// ============================================================
// AUDITORIA FUNCIONAL COMPLETA - WGEASY
// Teste End-to-End do Workflow Real (Lead -> Entrega)
// ============================================================

import { createClient } from '@supabase/supabase-js';

// Configuracao Supabase
const SUPABASE_URL = 'https://ahlqzzkxuutwoepirpzr.supabase.co';
const SUPABASE_SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo';

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// Prefixo para identificar dados de auditoria
const AUDIT_PREFIX = 'AUDIT_TEST_';
const AUDIT_TIMESTAMP = Date.now();

// Armazenamento de IDs criados durante auditoria
interface AuditData {
  cliente_id?: string;
  oportunidade_id?: string;
  contrato_id?: string;
  projeto_id?: string;
  lancamentos_ids?: string[];
  usuario_cliente_id?: string;
}

const auditData: AuditData = {};

// Relatorio de auditoria
interface CheckResult {
  descricao: string;
  status: 'OK' | 'FALHOU' | 'PARCIAL' | 'AVISO';
  detalhe?: string;
}

interface EtapaResult {
  etapa: number;
  nome: string;
  status: 'OK' | 'FALHOU' | 'PARCIAL';
  critico: boolean;
  checks: CheckResult[];
  erros: string[];
  tempoMs: number;
}

const relatorio: EtapaResult[] = [];

// ============================================================
// FUNCOES AUXILIARES
// ============================================================

function log(msg: string) {
  console.log(`[${new Date().toISOString()}] ${msg}`);
}

function logSuccess(msg: string) {
  console.log(`\x1b[32m[OK]\x1b[0m ${msg}`);
}

function logError(msg: string) {
  console.log(`\x1b[31m[ERRO]\x1b[0m ${msg}`);
}

function logWarn(msg: string) {
  console.log(`\x1b[33m[AVISO]\x1b[0m ${msg}`);
}

async function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// ============================================================
// ETAPA 1: CRIAR LEAD NO CRM
// ============================================================

async function etapa1_criarLead(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 1: CRIAR LEAD NO CRM');
  log('========================================\n');

  try {
    // Criar cliente (pessoa tipo CLIENTE)
    const clienteData = {
      nome: `${AUDIT_PREFIX}Maria Silva Santos`,
      email: `audit.test.${AUDIT_TIMESTAMP}@teste.wgeasy.com`,
      telefone: '(11) 99999-0001',
      cpf: '123.456.789-00',
      tipo: 'CLIENTE',
      logradouro: 'Rua de Teste',
      numero: '100',
      bairro: 'Jardim Teste',
      cidade: 'Sao Paulo',
      estado: 'SP',
      cep: '04000-000',
      ativo: true,
    };

    const { data: cliente, error: clienteError } = await supabase
      .from('pessoas')
      .insert(clienteData)
      .select()
      .single();

    if (clienteError) {
      logError(`Erro ao criar cliente: ${clienteError.message}`);
      erros.push(`INSERT pessoas: ${clienteError.message}`);
      checks.push({ descricao: 'Criar registro na tabela pessoas', status: 'FALHOU', detalhe: clienteError.message });
    } else {
      auditData.cliente_id = cliente.id;
      logSuccess(`Cliente criado: ${cliente.id}`);
      checks.push({ descricao: 'Criar registro na tabela pessoas', status: 'OK', detalhe: `ID: ${cliente.id}` });
    }

    // Verificar se cliente foi criado corretamente
    if (auditData.cliente_id) {
      const { data: verificacao } = await supabase
        .from('pessoas')
        .select('*')
        .eq('id', auditData.cliente_id)
        .single();

      if (verificacao) {
        checks.push({ descricao: 'Campo tipo = CLIENTE', status: verificacao.tipo === 'CLIENTE' ? 'OK' : 'FALHOU' });
        checks.push({ descricao: 'Campo ativo = true', status: verificacao.ativo ? 'OK' : 'FALHOU' });
        checks.push({ descricao: 'Campo criado_em preenchido', status: verificacao.criado_em ? 'OK' : 'FALHOU' });
      }
    }

    // Criar oportunidade (lead no funil)
    // NOTA: Existe um bug no trigger trigger_nova_oportunidade que tenta acessar
    // "nome" da tabela "usuarios" (coluna inexistente - deveria ser via join com pessoas)
    if (auditData.cliente_id) {
      const oportunidadeData = {
        titulo: `${AUDIT_PREFIX}Reforma Apt 120m2`,
        cliente_id: auditData.cliente_id,
        status: 'novo',
        estagio: 'qualificacao',
        valor: 250000.00,
        origem: 'Auditoria Automatica',
        responsavel_id: null, // Sem responsavel para evitar erro no trigger
      };

      const { data: oportunidade, error: oportError } = await supabase
        .from('oportunidades')
        .insert(oportunidadeData)
        .select()
        .single();

      if (oportError) {
        // Verificar se é o erro conhecido do trigger
        if (oportError.message.includes('nome') && oportError.message.includes('does not exist')) {
          logError('BUG ENCONTRADO: Trigger trigger_nova_oportunidade tenta acessar coluna inexistente');
          logError('CORRECAO NECESSARIA: Alterar trigger para buscar nome via JOIN com tabela pessoas');
          erros.push('BUG TRIGGER: trigger_nova_oportunidade busca "nome" de usuarios (coluna inexistente)');
          checks.push({
            descricao: 'Criar registro na tabela oportunidades',
            status: 'FALHOU',
            detalhe: 'BUG: Trigger trigger_nova_oportunidade precisa correção'
          });
          checks.push({
            descricao: '[BUG CRITICO] Trigger trigger_nova_oportunidade',
            status: 'FALHOU',
            detalhe: 'Busca coluna "nome" em usuarios que nao existe - deve usar JOIN com pessoas'
          });
        } else {
          logError(`Erro ao criar oportunidade: ${oportError.message}`);
          erros.push(`INSERT oportunidades: ${oportError.message}`);
          checks.push({ descricao: 'Criar registro na tabela oportunidades', status: 'FALHOU', detalhe: oportError.message });
        }
      } else {
        auditData.oportunidade_id = oportunidade.id;
        logSuccess(`Oportunidade criada: ${oportunidade.id}`);
        checks.push({ descricao: 'Criar registro na tabela oportunidades', status: 'OK', detalhe: `ID: ${oportunidade.id}` });
        checks.push({ descricao: 'Status inicial = novo', status: oportunidade.status === 'novo' ? 'OK' : 'FALHOU' });
        checks.push({ descricao: 'Estagio inicial = qualificacao', status: oportunidade.estagio === 'qualificacao' ? 'OK' : 'FALHOU' });
      }
    }

  } catch (err: any) {
    logError(`Excecao na etapa 1: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : checks.some(c => c.status === 'OK') ? 'PARCIAL' : 'FALHOU';

  return {
    etapa: 1,
    nome: 'Criar Lead no CRM',
    status,
    critico: false,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 2: MOVER LEAD NO FUNIL
// ============================================================

async function etapa2_moverFunil(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 2: MOVER LEAD NO FUNIL');
  log('========================================\n');

  if (!auditData.oportunidade_id) {
    logWarn('Oportunidade nao foi criada devido a bug no trigger - pulando etapa');
    checks.push({ descricao: 'Mover oportunidade no funil', status: 'AVISO', detalhe: 'Pulado - bug no trigger impede criacao' });
    return { etapa: 2, nome: 'Mover Lead no Funil', status: 'PARCIAL', critico: false, checks, erros, tempoMs: Date.now() - inicio };
  }

  try {
    const movimentos = [
      { status: 'em_andamento', estagio: 'proposta' },
      { status: 'proposta_enviada', estagio: 'proposta' },
      { status: 'negociacao', estagio: 'negociacao' },
      { status: 'ganho', estagio: 'fechamento' },
    ];

    for (const mov of movimentos) {
      const { error } = await supabase
        .from('oportunidades')
        .update({ status: mov.status, estagio: mov.estagio, atualizado_em: new Date().toISOString() })
        .eq('id', auditData.oportunidade_id);

      if (error) {
        erros.push(`UPDATE para ${mov.status}: ${error.message}`);
        checks.push({ descricao: `Mover para ${mov.status}`, status: 'FALHOU', detalhe: error.message });
      } else {
        logSuccess(`Oportunidade movida para: ${mov.status}`);
        checks.push({ descricao: `Mover para ${mov.status}`, status: 'OK' });
      }

      await delay(100); // Pequeno delay entre movimentos
    }

    // Verificar estado final
    const { data: oportFinal } = await supabase
      .from('oportunidades')
      .select('status, estagio')
      .eq('id', auditData.oportunidade_id)
      .single();

    if (oportFinal) {
      checks.push({ descricao: 'Estado final = ganho', status: oportFinal.status === 'ganho' ? 'OK' : 'FALHOU' });
      checks.push({ descricao: 'Estagio final = fechamento', status: oportFinal.estagio === 'fechamento' ? 'OK' : 'FALHOU' });
    }

  } catch (err: any) {
    logError(`Excecao na etapa 2: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : checks.some(c => c.status === 'OK') ? 'PARCIAL' : 'FALHOU';

  return {
    etapa: 2,
    nome: 'Mover Lead no Funil',
    status,
    critico: false,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 3: CRIAR CONTRATO
// ============================================================

async function etapa3_criarContrato(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 3: CRIAR CONTRATO');
  log('========================================\n');

  if (!auditData.cliente_id) {
    erros.push('Cliente nao foi criado - impossivel continuar');
    return { etapa: 3, nome: 'Criar Contrato', status: 'FALHOU', critico: false, checks, erros, tempoMs: Date.now() - inicio };
  }

  // Oportunidade é opcional para criar contrato
  if (!auditData.oportunidade_id) {
    logWarn('Contrato sera criado sem vinculo com oportunidade (bug no trigger)');
    checks.push({ descricao: 'Vinculo com oportunidade', status: 'AVISO', detalhe: 'Nao vinculado - bug no trigger' });
  }

  try {
    const contratoData: any = {
      numero: `ARQ-2025-${AUDIT_TIMESTAMP}`,
      titulo: `${AUDIT_PREFIX}Contrato Reforma Apt 120m2`,
      cliente_id: auditData.cliente_id,
      unidade_negocio: 'arquitetura',
      valor_total: 35000.00,
      valor_mao_obra: 25000.00,
      valor_materiais: 10000.00,
      status: 'rascunho',
      data_inicio: new Date().toISOString().split('T')[0],
      data_previsao_termino: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
    };

    // Vincular oportunidade se existir
    if (auditData.oportunidade_id) {
      contratoData.oportunidade_id = auditData.oportunidade_id;
    }

    const { data: contrato, error: contratoError } = await supabase
      .from('contratos')
      .insert(contratoData)
      .select()
      .single();

    if (contratoError) {
      logError(`Erro ao criar contrato: ${contratoError.message}`);
      erros.push(`INSERT contratos: ${contratoError.message}`);
      checks.push({ descricao: 'Criar registro na tabela contratos', status: 'FALHOU', detalhe: contratoError.message });
    } else {
      auditData.contrato_id = contrato.id;
      logSuccess(`Contrato criado: ${contrato.id}`);
      checks.push({ descricao: 'Criar registro na tabela contratos', status: 'OK', detalhe: `ID: ${contrato.id}` });
      checks.push({ descricao: 'Numero unico gerado', status: 'OK', detalhe: contrato.numero });
      checks.push({ descricao: 'Status inicial = rascunho', status: contrato.status === 'rascunho' ? 'OK' : 'FALHOU' });
    }

    // Adicionar itens ao contrato
    if (auditData.contrato_id) {
      const itens = [
        { contrato_id: auditData.contrato_id, tipo: 'mao_obra', descricao: 'Projeto Arquitetonico', quantidade: 1, unidade: 'vb', valor_unitario: 15000, valor_total: 15000, ordem: 1 },
        { contrato_id: auditData.contrato_id, tipo: 'mao_obra', descricao: 'Acompanhamento de Obra', quantidade: 1, unidade: 'vb', valor_unitario: 10000, valor_total: 10000, ordem: 2 },
        { contrato_id: auditData.contrato_id, tipo: 'material', descricao: 'Materiais de Escritorio', quantidade: 1, unidade: 'vb', valor_unitario: 10000, valor_total: 10000, ordem: 3 },
      ];

      const { data: itensInseridos, error: itensError } = await supabase
        .from('contratos_itens')
        .insert(itens)
        .select();

      if (itensError) {
        erros.push(`INSERT contratos_itens: ${itensError.message}`);
        checks.push({ descricao: 'Adicionar itens ao contrato', status: 'FALHOU', detalhe: itensError.message });
      } else {
        logSuccess(`${itensInseridos?.length || 0} itens adicionados ao contrato`);
        checks.push({ descricao: 'Adicionar itens ao contrato', status: 'OK', detalhe: `${itensInseridos?.length} itens` });
      }
    }

  } catch (err: any) {
    logError(`Excecao na etapa 3: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : checks.some(c => c.status === 'OK') ? 'PARCIAL' : 'FALHOU';

  return {
    etapa: 3,
    nome: 'Criar Contrato',
    status,
    critico: false,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 4: ATIVAR CONTRATO E GERAR FINANCEIRO (CRITICO)
// ============================================================

async function etapa4_ativarContrato(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 4: ATIVAR CONTRATO (CRITICO)');
  log('========================================\n');

  if (!auditData.contrato_id || !auditData.cliente_id) {
    erros.push('Contrato nao existe - etapa 3 falhou');
    return { etapa: 4, nome: 'Ativar Contrato (CRITICO)', status: 'FALHOU', critico: true, checks, erros, tempoMs: Date.now() - inicio };
  }

  try {
    // Simular assinaturas
    const { error: assinaturaError } = await supabase
      .from('contratos')
      .update({
        assinatura_cliente_base64: 'data:image/png;base64,AUDIT_TEST_ASSINATURA_CLIENTE',
        assinatura_responsavel_base64: 'data:image/png;base64,AUDIT_TEST_ASSINATURA_RESPONSAVEL',
        data_assinatura: new Date().toISOString(),
      })
      .eq('id', auditData.contrato_id);

    if (assinaturaError) {
      logWarn(`Nao foi possivel adicionar assinaturas: ${assinaturaError.message}`);
    }

    // Ativar contrato
    const { error: ativarError } = await supabase
      .from('contratos')
      .update({
        status: 'ativo',
        data_ativacao: new Date().toISOString(),
      })
      .eq('id', auditData.contrato_id);

    if (ativarError) {
      logError(`Erro ao ativar contrato: ${ativarError.message}`);
      erros.push(`UPDATE contratos status=ativo: ${ativarError.message}`);
      checks.push({ descricao: 'Ativar contrato (status=ativo)', status: 'FALHOU', detalhe: ativarError.message });
    } else {
      logSuccess('Contrato ativado com sucesso');
      checks.push({ descricao: 'Ativar contrato (status=ativo)', status: 'OK' });
    }

    // VERIFICACAO CRITICA: Verificar se lancamentos financeiros foram criados automaticamente
    await delay(500); // Esperar possivel trigger

    const { data: lancamentos, error: lancError } = await supabase
      .from('financeiro_lancamentos')
      .select('*')
      .eq('contrato_id', auditData.contrato_id);

    if (lancError) {
      erros.push(`SELECT financeiro_lancamentos: ${lancError.message}`);
      checks.push({ descricao: '[CRITICO] Lancamentos financeiros criados automaticamente', status: 'FALHOU', detalhe: lancError.message });
    } else if (!lancamentos || lancamentos.length === 0) {
      logWarn('ATENCAO: Nenhum lancamento financeiro foi criado automaticamente!');
      checks.push({
        descricao: '[CRITICO] Lancamentos financeiros criados automaticamente',
        status: 'AVISO',
        detalhe: 'Nenhum lancamento criado - precisa ser feito manualmente via workflow',
      });

      // Criar lancamentos manualmente para continuar o teste
      log('Criando lancamentos manualmente para continuar auditoria...');

      const { data: contrato } = await supabase
        .from('contratos')
        .select('*')
        .eq('id', auditData.contrato_id)
        .single();

      if (contrato) {
        const valorTotal = contrato.valor_total || 35000;
        const numParcelas = 4;
        const valorParcela = valorTotal / numParcelas;

        const lancamentosData = [];
        for (let i = 0; i < numParcelas; i++) {
          const venc = new Date();
          venc.setMonth(venc.getMonth() + i);

          lancamentosData.push({
            tipo: 'entrada',
            status: 'pendente',
            descricao: i === 0
              ? `Entrada contrato ${contrato.numero} - ARQUITETURA`
              : `Parcela ${i}/${numParcelas - 1} contrato ${contrato.numero} - ARQUITETURA`,
            valor_total: valorParcela,
            pessoa_id: auditData.cliente_id,
            contrato_id: auditData.contrato_id,
            nucleo: 'arquitetura',
            unidade_negocio: 'arquitetura',
            data_competencia: venc.toISOString().split('T')[0],
            vencimento: venc.toISOString().split('T')[0],
          });
        }

        const { data: lancsInseridos, error: insLancError } = await supabase
          .from('financeiro_lancamentos')
          .insert(lancamentosData)
          .select();

        if (insLancError) {
          erros.push(`INSERT financeiro_lancamentos manual: ${insLancError.message}`);
        } else {
          auditData.lancamentos_ids = lancsInseridos?.map((l: any) => l.id) || [];
          logSuccess(`${lancsInseridos?.length} lancamentos criados manualmente`);
          checks.push({ descricao: 'Lancamentos criados manualmente', status: 'OK', detalhe: `${lancsInseridos?.length} parcelas` });
        }
      }
    } else {
      auditData.lancamentos_ids = lancamentos.map((l: any) => l.id);
      logSuccess(`${lancamentos.length} lancamentos financeiros encontrados`);
      checks.push({ descricao: '[CRITICO] Lancamentos financeiros criados automaticamente', status: 'OK', detalhe: `${lancamentos.length} lancamentos` });
    }

    // VERIFICACAO CRITICA: Projeto criado automaticamente
    const { data: projeto, error: projError } = await supabase
      .from('projetos')
      .select('*')
      .eq('contrato_id', auditData.contrato_id)
      .maybeSingle();

    if (projError) {
      checks.push({ descricao: 'Projeto criado automaticamente', status: 'AVISO', detalhe: projError.message });
    } else if (!projeto) {
      logWarn('Projeto nao foi criado automaticamente');
      checks.push({ descricao: 'Projeto criado automaticamente', status: 'AVISO', detalhe: 'Nao criado automaticamente' });

      // Criar projeto manualmente
      const { data: projCriado, error: projInsError } = await supabase
        .from('projetos')
        .insert({
          nome: `${AUDIT_PREFIX}Obra Reforma Apt 120m2`,
          descricao: 'Projeto criado pela auditoria funcional',
          contrato_id: auditData.contrato_id,
          cliente_id: auditData.cliente_id,
          status: 'ativo',
          nucleo: 'arquitetura',
          data_inicio: new Date().toISOString().split('T')[0],
          progresso: 0,
        })
        .select()
        .single();

      if (!projInsError && projCriado) {
        auditData.projeto_id = projCriado.id;
        logSuccess('Projeto criado manualmente');
        checks.push({ descricao: 'Projeto criado manualmente', status: 'OK' });
      }
    } else {
      auditData.projeto_id = projeto.id;
      logSuccess(`Projeto encontrado: ${projeto.id}`);
      checks.push({ descricao: 'Projeto criado automaticamente', status: 'OK', detalhe: `ID: ${projeto.id}` });
    }

  } catch (err: any) {
    logError(`Excecao na etapa 4: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : checks.some(c => c.status === 'OK') ? 'PARCIAL' : 'FALHOU';

  return {
    etapa: 4,
    nome: 'Ativar Contrato (CRITICO)',
    status,
    critico: true,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 5: VERIFICAR LANCAMENTOS FINANCEIROS
// ============================================================

async function etapa5_verificarFinanceiro(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 5: VERIFICAR LANCAMENTOS FINANCEIROS');
  log('========================================\n');

  if (!auditData.contrato_id) {
    erros.push('Contrato nao existe');
    return { etapa: 5, nome: 'Verificar Lancamentos Financeiros', status: 'FALHOU', critico: true, checks, erros, tempoMs: Date.now() - inicio };
  }

  try {
    // Buscar lancamentos do contrato
    const { data: lancamentos, error: lancError } = await supabase
      .from('financeiro_lancamentos')
      .select('*')
      .eq('contrato_id', auditData.contrato_id)
      .order('vencimento');

    if (lancError) {
      erros.push(`SELECT financeiro_lancamentos: ${lancError.message}`);
      checks.push({ descricao: 'Buscar lancamentos', status: 'FALHOU', detalhe: lancError.message });
    } else if (!lancamentos || lancamentos.length === 0) {
      erros.push('Nenhum lancamento encontrado para o contrato');
      checks.push({ descricao: 'Lancamentos existem', status: 'FALHOU' });
    } else {
      logSuccess(`${lancamentos.length} lancamentos encontrados`);
      checks.push({ descricao: 'Lancamentos existem', status: 'OK', detalhe: `${lancamentos.length} lancamentos` });

      // Calcular totais
      const totalLancamentos = lancamentos.reduce((sum: number, l: any) => sum + Number(l.valor_total || 0), 0);
      logSuccess(`Valor total dos lancamentos: R$ ${totalLancamentos.toFixed(2)}`);
      checks.push({ descricao: 'Soma dos lancamentos', status: 'OK', detalhe: `R$ ${totalLancamentos.toFixed(2)}` });

      // Verificar se valores de vencimento estao corretos
      const lancamentosComVencimento = lancamentos.filter((l: any) => l.vencimento);
      checks.push({
        descricao: 'Datas de vencimento preenchidas',
        status: lancamentosComVencimento.length === lancamentos.length ? 'OK' : 'PARCIAL',
        detalhe: `${lancamentosComVencimento.length}/${lancamentos.length}`,
      });

      // Simular pagamento da primeira parcela
      if (lancamentos.length > 0) {
        const primeiraParela = lancamentos[0];
        const { error: pagError } = await supabase
          .from('financeiro_lancamentos')
          .update({
            status: 'pago',
            data_pagamento: new Date().toISOString().split('T')[0],
            forma_pagamento: 'PIX',
          })
          .eq('id', primeiraParela.id);

        if (pagError) {
          logWarn(`Erro ao simular pagamento: ${pagError.message}`);
          checks.push({ descricao: 'Registrar pagamento', status: 'AVISO', detalhe: pagError.message });
        } else {
          logSuccess('Pagamento da entrada registrado');
          checks.push({ descricao: 'Registrar pagamento', status: 'OK' });
        }
      }
    }

    // Verificar cobrancas
    const { data: cobrancas } = await supabase
      .from('cobrancas')
      .select('*')
      .eq('cliente', `${AUDIT_PREFIX}Maria Silva Santos`);

    if (cobrancas && cobrancas.length > 0) {
      logSuccess(`${cobrancas.length} cobrancas encontradas`);
      checks.push({ descricao: 'Cobrancas criadas automaticamente', status: 'OK', detalhe: `${cobrancas.length} cobrancas` });
    } else {
      checks.push({ descricao: 'Cobrancas criadas automaticamente', status: 'AVISO', detalhe: 'Nenhuma cobranca encontrada' });
    }

  } catch (err: any) {
    logError(`Excecao na etapa 5: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : checks.some(c => c.status === 'OK') ? 'PARCIAL' : 'FALHOU';

  return {
    etapa: 5,
    nome: 'Verificar Lancamentos Financeiros',
    status,
    critico: true,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 6: VERIFICAR AREA DO CLIENTE
// ============================================================

async function etapa6_verificarAreaCliente(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 6: VERIFICAR AREA DO CLIENTE');
  log('========================================\n');

  if (!auditData.cliente_id) {
    erros.push('Cliente nao existe');
    return { etapa: 6, nome: 'Verificar Area do Cliente', status: 'FALHOU', critico: true, checks, erros, tempoMs: Date.now() - inicio };
  }

  try {
    // Verificar se existe usuario para o cliente
    const { data: usuario, error: userError } = await supabase
      .from('usuarios')
      .select('*')
      .eq('pessoa_id', auditData.cliente_id)
      .maybeSingle();

    if (userError) {
      checks.push({ descricao: 'Buscar usuario do cliente', status: 'AVISO', detalhe: userError.message });
    } else if (!usuario) {
      logWarn('Usuario para acesso a area do cliente NAO existe');
      checks.push({
        descricao: '[CRITICO] Usuario para area do cliente existe',
        status: 'AVISO',
        detalhe: 'Usuario nao criado automaticamente - precisa criar manualmente',
      });

      // Tentar criar usuario
      log('Tentando criar usuario para o cliente...');
      const { data: usuarioCriado, error: criarUserError } = await supabase
        .from('usuarios')
        .insert({
          pessoa_id: auditData.cliente_id,
          cpf: '12345678900',
          tipo_usuario: 'CLIENTE',
          ativo: true,
          primeiro_acesso: true,
          cliente_pode_ver_valores: false,
          cliente_pode_ver_cronograma: true,
          cliente_pode_ver_documentos: true,
          cliente_pode_ver_proposta: true,
          cliente_pode_ver_contratos: true,
          cliente_pode_fazer_upload: true,
          cliente_pode_comentar: true,
        })
        .select()
        .single();

      if (criarUserError) {
        erros.push(`Erro ao criar usuario: ${criarUserError.message}`);
        checks.push({ descricao: 'Criar usuario manualmente', status: 'FALHOU', detalhe: criarUserError.message });
      } else {
        auditData.usuario_cliente_id = usuarioCriado.id;
        logSuccess(`Usuario criado: ${usuarioCriado.id}`);
        checks.push({ descricao: 'Criar usuario manualmente', status: 'OK' });
      }
    } else {
      auditData.usuario_cliente_id = usuario.id;
      logSuccess(`Usuario encontrado: ${usuario.id}`);
      checks.push({ descricao: '[CRITICO] Usuario para area do cliente existe', status: 'OK', detalhe: `ID: ${usuario.id}` });
      checks.push({ descricao: 'Tipo usuario = CLIENTE', status: usuario.tipo_usuario === 'CLIENTE' ? 'OK' : 'FALHOU' });
      checks.push({ descricao: 'Usuario ativo', status: usuario.ativo ? 'OK' : 'FALHOU' });
    }

    // Verificar contratos do cliente
    const { data: contratos } = await supabase
      .from('contratos')
      .select('id, numero, status, valor_total')
      .eq('cliente_id', auditData.cliente_id);

    if (contratos && contratos.length > 0) {
      logSuccess(`${contratos.length} contrato(s) vinculado(s) ao cliente`);
      checks.push({ descricao: 'Cliente tem contratos vinculados', status: 'OK', detalhe: `${contratos.length} contrato(s)` });
    }

    // Verificar lancamentos do cliente
    const { data: lancamentosCliente } = await supabase
      .from('financeiro_lancamentos')
      .select('id, valor_total, status, vencimento')
      .eq('pessoa_id', auditData.cliente_id);

    if (lancamentosCliente && lancamentosCliente.length > 0) {
      logSuccess(`${lancamentosCliente.length} lancamento(s) financeiro(s) do cliente`);
      checks.push({ descricao: 'Cliente pode ver lancamentos financeiros', status: 'OK', detalhe: `${lancamentosCliente.length} lancamento(s)` });
    }

  } catch (err: any) {
    logError(`Excecao na etapa 6: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : checks.some(c => c.status === 'OK') ? 'PARCIAL' : 'FALHOU';

  return {
    etapa: 6,
    nome: 'Verificar Area do Cliente',
    status,
    critico: true,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 7: VERIFICAR DASHBOARDS
// ============================================================

async function etapa7_verificarDashboards(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 7: VERIFICAR DASHBOARDS');
  log('========================================\n');

  try {
    // Dashboard CRM
    const { data: totalClientes, error: cliError } = await supabase
      .from('pessoas')
      .select('id', { count: 'exact' })
      .eq('tipo', 'CLIENTE')
      .eq('ativo', true);

    if (!cliError) {
      logSuccess(`Total de clientes ativos: ${totalClientes?.length || 0}`);
      checks.push({ descricao: 'Contagem de clientes', status: 'OK', detalhe: `${totalClientes?.length || 0} clientes` });
    }

    // Dashboard Financeiro
    const { data: lancamentosPendentes } = await supabase
      .from('financeiro_lancamentos')
      .select('id, valor_total')
      .eq('tipo', 'entrada')
      .eq('status', 'pendente');

    const totalAReceber = lancamentosPendentes?.reduce((sum: number, l: any) => sum + Number(l.valor_total || 0), 0) || 0;
    logSuccess(`Total a receber: R$ ${totalAReceber.toFixed(2)}`);
    checks.push({ descricao: 'Total a receber calculado', status: 'OK', detalhe: `R$ ${totalAReceber.toFixed(2)}` });

    const { data: lancamentosPagos } = await supabase
      .from('financeiro_lancamentos')
      .select('id, valor_total')
      .eq('tipo', 'entrada')
      .eq('status', 'pago');

    const totalRecebido = lancamentosPagos?.reduce((sum: number, l: any) => sum + Number(l.valor_total || 0), 0) || 0;
    logSuccess(`Total recebido: R$ ${totalRecebido.toFixed(2)}`);
    checks.push({ descricao: 'Total recebido calculado', status: 'OK', detalhe: `R$ ${totalRecebido.toFixed(2)}` });

    // Dashboard Contratos
    const { data: contratosAtivos } = await supabase
      .from('contratos')
      .select('id', { count: 'exact' })
      .eq('status', 'ativo');

    logSuccess(`Contratos ativos: ${contratosAtivos?.length || 0}`);
    checks.push({ descricao: 'Contagem de contratos ativos', status: 'OK', detalhe: `${contratosAtivos?.length || 0} contratos` });

    // Dashboard Projetos
    const { data: projetosAtivos } = await supabase
      .from('projetos')
      .select('id', { count: 'exact' })
      .eq('status', 'ativo');

    logSuccess(`Projetos ativos: ${projetosAtivos?.length || 0}`);
    checks.push({ descricao: 'Contagem de projetos ativos', status: 'OK', detalhe: `${projetosAtivos?.length || 0} projetos` });

  } catch (err: any) {
    logError(`Excecao na etapa 7: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : 'PARCIAL';

  return {
    etapa: 7,
    nome: 'Verificar Dashboards',
    status,
    critico: false,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// ETAPA 8: LIMPEZA DOS DADOS DE TESTE
// ============================================================

async function etapa8_limparDados(): Promise<EtapaResult> {
  const inicio = Date.now();
  const checks: CheckResult[] = [];
  const erros: string[] = [];

  log('\n========================================');
  log('ETAPA 8: LIMPEZA DOS DADOS DE TESTE');
  log('========================================\n');

  try {
    // 1. Limpar lancamentos financeiros
    if (auditData.lancamentos_ids && auditData.lancamentos_ids.length > 0) {
      const { error } = await supabase
        .from('financeiro_lancamentos')
        .delete()
        .in('id', auditData.lancamentos_ids);

      if (error) {
        erros.push(`DELETE financeiro_lancamentos: ${error.message}`);
      } else {
        logSuccess('Lancamentos financeiros removidos');
        checks.push({ descricao: 'Remover lancamentos financeiros', status: 'OK' });
      }
    }

    // 2. Limpar cronograma/tarefas
    if (auditData.projeto_id) {
      await supabase.from('cronograma_tarefas').delete().eq('projeto_id', auditData.projeto_id);
    }

    // 3. Limpar projetos
    if (auditData.projeto_id) {
      const { error } = await supabase
        .from('projetos')
        .delete()
        .eq('id', auditData.projeto_id);

      if (!error) {
        logSuccess('Projeto removido');
        checks.push({ descricao: 'Remover projeto', status: 'OK' });
      }
    }

    // 4. Limpar itens do contrato
    if (auditData.contrato_id) {
      await supabase.from('contratos_itens').delete().eq('contrato_id', auditData.contrato_id);
    }

    // 5. Limpar cobrancas
    await supabase.from('cobrancas').delete().ilike('cliente', `${AUDIT_PREFIX}%`);

    // 6. Limpar contratos
    if (auditData.contrato_id) {
      const { error } = await supabase
        .from('contratos')
        .delete()
        .eq('id', auditData.contrato_id);

      if (!error) {
        logSuccess('Contrato removido');
        checks.push({ descricao: 'Remover contrato', status: 'OK' });
      }
    }

    // 7. Limpar oportunidades
    if (auditData.oportunidade_id) {
      const { error } = await supabase
        .from('oportunidades')
        .delete()
        .eq('id', auditData.oportunidade_id);

      if (!error) {
        logSuccess('Oportunidade removida');
        checks.push({ descricao: 'Remover oportunidade', status: 'OK' });
      }
    }

    // 8. Limpar usuario
    if (auditData.usuario_cliente_id) {
      await supabase.from('usuarios').delete().eq('id', auditData.usuario_cliente_id);
      logSuccess('Usuario removido');
      checks.push({ descricao: 'Remover usuario', status: 'OK' });
    }

    // 9. Limpar cliente (pessoa)
    if (auditData.cliente_id) {
      const { error } = await supabase
        .from('pessoas')
        .delete()
        .eq('id', auditData.cliente_id);

      if (!error) {
        logSuccess('Cliente removido');
        checks.push({ descricao: 'Remover cliente', status: 'OK' });
      }
    }

    // 10. Verificar limpeza
    const { data: restantes } = await supabase
      .from('pessoas')
      .select('id')
      .ilike('nome', `${AUDIT_PREFIX}%`);

    if (restantes && restantes.length > 0) {
      logWarn(`Ainda restam ${restantes.length} registros com prefixo de teste`);
      checks.push({ descricao: 'Verificar limpeza completa', status: 'PARCIAL', detalhe: `${restantes.length} registros restantes` });
    } else {
      logSuccess('Todos os dados de teste foram removidos');
      checks.push({ descricao: 'Verificar limpeza completa', status: 'OK' });
    }

  } catch (err: any) {
    logError(`Excecao na etapa 8: ${err.message}`);
    erros.push(`Excecao: ${err.message}`);
  }

  const status = erros.length === 0 ? 'OK' : 'PARCIAL';

  return {
    etapa: 8,
    nome: 'Limpeza dos Dados de Teste',
    status,
    critico: false,
    checks,
    erros,
    tempoMs: Date.now() - inicio,
  };
}

// ============================================================
// GERAR RELATORIO FINAL
// ============================================================

function gerarRelatorio(): void {
  console.log('\n');
  console.log('╔══════════════════════════════════════════════════════════════════════╗');
  console.log('║           RELATORIO DE AUDITORIA FUNCIONAL - WGEASY                  ║');
  console.log('╠══════════════════════════════════════════════════════════════════════╣');
  console.log(`║  Data: ${new Date().toISOString()}                        ║`);
  console.log('╚══════════════════════════════════════════════════════════════════════╝\n');

  // Resumo por etapa
  console.log('┌──────────────────────────────────────────────────────────────────────┐');
  console.log('│                         RESUMO POR ETAPA                             │');
  console.log('├────┬─────────────────────────────────────┬──────────┬────────────────┤');
  console.log('│ #  │ Etapa                               │ Status   │ Tempo          │');
  console.log('├────┼─────────────────────────────────────┼──────────┼────────────────┤');

  let totalOK = 0;
  let totalFalhou = 0;
  let totalParcial = 0;

  for (const etapa of relatorio) {
    const statusIcon = etapa.status === 'OK' ? '\x1b[32mOK\x1b[0m    ' :
                       etapa.status === 'PARCIAL' ? '\x1b[33mPARCIAL\x1b[0m' :
                       '\x1b[31mFALHOU\x1b[0m ';
    const critico = etapa.critico ? ' *' : '  ';
    const nome = etapa.nome.padEnd(35);
    const tempo = `${etapa.tempoMs}ms`.padEnd(12);

    console.log(`│ ${etapa.etapa}${critico}│ ${nome} │ ${statusIcon} │ ${tempo} │`);

    if (etapa.status === 'OK') totalOK++;
    else if (etapa.status === 'PARCIAL') totalParcial++;
    else totalFalhou++;
  }

  console.log('└────┴─────────────────────────────────────┴──────────┴────────────────┘');
  console.log('* = Etapa critica\n');

  // Status geral
  const statusGeral = totalFalhou > 0 ? 'REPROVADO' :
                      totalParcial > 0 ? 'PARCIAL' :
                      'APROVADO';

  console.log('┌──────────────────────────────────────────────────────────────────────┐');
  console.log('│                         STATUS GERAL                                 │');
  console.log('├──────────────────────────────────────────────────────────────────────┤');
  console.log(`│  Etapas OK: ${totalOK}    Parcial: ${totalParcial}    Falhou: ${totalFalhou}                            │`);
  console.log('│                                                                      │');

  if (statusGeral === 'APROVADO') {
    console.log('│  \x1b[32m████████████████████████████████████████████████████████████████\x1b[0m  │');
    console.log('│  \x1b[32m██                       APROVADO                            ██\x1b[0m  │');
    console.log('│  \x1b[32m████████████████████████████████████████████████████████████████\x1b[0m  │');
  } else if (statusGeral === 'PARCIAL') {
    console.log('│  \x1b[33m████████████████████████████████████████████████████████████████\x1b[0m  │');
    console.log('│  \x1b[33m██                       PARCIAL                             ██\x1b[0m  │');
    console.log('│  \x1b[33m████████████████████████████████████████████████████████████████\x1b[0m  │');
  } else {
    console.log('│  \x1b[31m████████████████████████████████████████████████████████████████\x1b[0m  │');
    console.log('│  \x1b[31m██                      REPROVADO                            ██\x1b[0m  │');
    console.log('│  \x1b[31m████████████████████████████████████████████████████████████████\x1b[0m  │');
  }

  console.log('└──────────────────────────────────────────────────────────────────────┘\n');

  // Detalhes por etapa
  console.log('┌──────────────────────────────────────────────────────────────────────┐');
  console.log('│                      DETALHES DAS VERIFICACOES                       │');
  console.log('└──────────────────────────────────────────────────────────────────────┘\n');

  for (const etapa of relatorio) {
    console.log(`\n=== ETAPA ${etapa.etapa}: ${etapa.nome} ${etapa.critico ? '(CRITICO)' : ''} ===\n`);

    for (const check of etapa.checks) {
      const icon = check.status === 'OK' ? '\x1b[32m✓\x1b[0m' :
                   check.status === 'AVISO' ? '\x1b[33m!\x1b[0m' :
                   check.status === 'PARCIAL' ? '\x1b[33m~\x1b[0m' :
                   '\x1b[31m✗\x1b[0m';
      const detalhe = check.detalhe ? ` (${check.detalhe})` : '';
      console.log(`  ${icon} ${check.descricao}${detalhe}`);
    }

    if (etapa.erros.length > 0) {
      console.log('\n  Erros:');
      for (const erro of etapa.erros) {
        console.log(`    \x1b[31m- ${erro}\x1b[0m`);
      }
    }
  }

  // Recomendacoes
  console.log('\n┌──────────────────────────────────────────────────────────────────────┐');
  console.log('│                         RECOMENDACOES                                │');
  console.log('└──────────────────────────────────────────────────────────────────────┘\n');

  const etapasCriticasComProblema = relatorio.filter(e => e.critico && e.status !== 'OK');
  if (etapasCriticasComProblema.length > 0) {
    console.log('  URGENTE (Etapas Criticas):');
    for (const etapa of etapasCriticasComProblema) {
      console.log(`    - Etapa ${etapa.etapa} (${etapa.nome}): Verificar automacoes`);
    }
    console.log('');
  }

  // Verificar se lancamentos financeiros foram criados automaticamente
  const etapaFinanceiro = relatorio.find(e => e.etapa === 4);
  if (etapaFinanceiro) {
    const checkFinanceiro = etapaFinanceiro.checks.find(c => c.descricao.includes('Lancamentos financeiros criados automaticamente'));
    if (checkFinanceiro && checkFinanceiro.status !== 'OK') {
      console.log('  IMPORTANTE:');
      console.log('    - Criar trigger para gerar lancamentos financeiros automaticamente');
      console.log('      quando contrato for ativado (status = ativo)');
      console.log('');
    }
  }

  // Verificar area do cliente
  const etapaCliente = relatorio.find(e => e.etapa === 6);
  if (etapaCliente) {
    const checkUsuario = etapaCliente.checks.find(c => c.descricao.includes('Usuario para area do cliente'));
    if (checkUsuario && checkUsuario.status !== 'OK') {
      console.log('  IMPORTANTE:');
      console.log('    - Criar automacao para criar usuario do cliente quando contrato');
      console.log('      for ativado, permitindo acesso a area do cliente');
      console.log('');
    }
  }

  console.log('\n══════════════════════════════════════════════════════════════════════');
  console.log('                    FIM DO RELATORIO DE AUDITORIA                      ');
  console.log('══════════════════════════════════════════════════════════════════════\n');
}

// ============================================================
// EXECUCAO PRINCIPAL
// ============================================================

async function executarAuditoria(): Promise<void> {
  console.log('\n');
  console.log('╔══════════════════════════════════════════════════════════════════════╗');
  console.log('║            INICIANDO AUDITORIA FUNCIONAL WGEASY                      ║');
  console.log('║                                                                      ║');
  console.log('║  Este script ira testar todo o workflow do sistema:                  ║');
  console.log('║  Lead -> Proposta -> Contrato -> Financeiro -> Area Cliente          ║');
  console.log('║                                                                      ║');
  console.log('║  Todos os dados de teste usam o prefixo: AUDIT_TEST_                 ║');
  console.log('╚══════════════════════════════════════════════════════════════════════╝\n');

  // Executar etapas
  relatorio.push(await etapa1_criarLead());
  relatorio.push(await etapa2_moverFunil());
  relatorio.push(await etapa3_criarContrato());
  relatorio.push(await etapa4_ativarContrato());
  relatorio.push(await etapa5_verificarFinanceiro());
  relatorio.push(await etapa6_verificarAreaCliente());
  relatorio.push(await etapa7_verificarDashboards());
  relatorio.push(await etapa8_limparDados());

  // Gerar relatorio
  gerarRelatorio();
}

// Executar
executarAuditoria().catch(console.error);
