---
prompt: /creative Today, AI model weights are static and are not updated during inference. How could we change this to treat session memory as weight updates, instead of feeding memory through parameters as part of the context? Memory should not grow the input context over time.
model: GPT-5.3
tool: ChatGPT mobile app
---

# Shadow Weights for Session Memory  
### A Practical Architecture for Non-Contextual LLM Memory

## Abstract

Modern large language models rely on static weights and growing context windows to simulate memory. This approach is inefficient, unbounded, and fundamentally limited.  

This document proposes an alternative: Shadow Weights — session-scoped parameter updates that act as memory without expanding input context.  

We focus on the core challenge of this paradigm: interference and forgetting, and present a practical architecture to manage both.

---

## 1. Motivation

Current memory approaches fall into three categories:

1. Context-based memory (prompt expansion)
2. External retrieval (RAG)
3. Fine-tuning (offline updates)

All suffer from trade-offs in scalability, latency, or adaptability.

Shadow Weights introduce a fourth option:

> Memory as temporary, local modifications to model parameters.

---

## 2. Core Idea

Instead of modifying base weights directly, we define:

W_effective = W_base + ΔW_session

Where:
- W_base is frozen
- ΔW_session is a small, dynamically updated parameter set

This allows:
- constant inference cost
- session-specific adaptation
- reversible memory

---

## 3. The Interference Problem

Unlike context, parameter updates are:

- global (affect all tokens)
- distributed (non-symbolic)
- persistent (hard to undo)

This leads to:

- memory collisions
- behavioral drift
- instability over time

Therefore, the system must explicitly manage interference.

---

## 4. Design Principles

### 4.1 Isolation

Memory must be partitioned into independent units.

We define:

ΔW_session = Σ ΔW_i

Each ΔW_i is a separate memory slot.

---

### 4.2 Contextual Gating

Not all memory should apply at all times.

W_effective = W_base + Σ g_i(x) · ΔW_i

Where g_i(x) is a relevance function.

---

### 4.3 Orthogonality

New memory updates should minimize overlap with existing ones.

Practical implementations:
- cosine similarity penalties
- projection into orthogonal subspaces

---

### 4.4 Temporal Decay

Memory should fade unless reinforced.

ΔW_i(t) = λ^t · ΔW_i

---

### 4.5 Bounded Capacity

Total memory must be constrained.

Strategies:
- slot limits
- norm constraints
- eviction policies

---

### 4.6 Consolidation

Periodic merging and compression of memory:

- reduces redundancy
- improves generalization
- stabilizes behavior

---

## 5. System Architecture

### Components

- Base Model: frozen LLM
- Memory Slots (ΔW_i): low-rank adapters (LoRA-style)
- Gating Network: selects relevant memory
- Memory Writer: generates updates
- Memory Controller: enforces constraints

---

### Inference Loop

1. Receive input x
2. Compute gating scores g_i(x)
3. Apply weighted ΔW
4. Generate output
5. Optionally update memory via writer

---

## 6. Failure Modes

### 6.1 Personality Drift
Mitigation:
- regularization toward base model
- norm constraints

### 6.2 Memory Dominance
Mitigation:
- normalize contributions
- cap slot influence

### 6.3 Slot Collision
Mitigation:
- improve gating
- enforce sparsity

### 6.4 Silent Degradation
Mitigation:
- periodic resets
- evaluation checkpoints

---

## 7. Key Insight

Shadow Weights are not suited for storing facts.

They are best used for:

- behavioral adaptation
- user preferences
- style and tone
- recurring patterns

---

## 8. Conclusion

Shadow Weights provide a promising path toward:

- bounded memory
- constant inference cost
- continuous adaptation

However, they require careful system design to avoid instability.

The core challenge is not writing memory —  
but controlling how memory interacts.

---

## 9. Future Work

- learned gating mechanisms
- hybrid context + weight systems
- hierarchical memory slots
- stability benchmarks

---

TL;DR:  
Memory in weights is possible — but only if you treat interference as a first-class problem, not an afterthought.