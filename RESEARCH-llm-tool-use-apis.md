# LLM Tool-Use / Function-Calling API Research

**Date:** 2026-02-15
**Purpose:** Practical reference for implementing a Swift client that supports tool-use across Anthropic, OpenAI, and Google Gemini APIs.

---

## Table of Contents

1. [Anthropic Claude API](#1-anthropic-claude-api)
2. [OpenAI API](#2-openai-api)
3. [Google Gemini API](#3-google-gemini-api)
4. [Cross-Provider Comparison](#4-cross-provider-comparison)
5. [Recommendation for Genomics Tool-Use App](#5-recommendation-for-genomics-tool-use-app)
6. [Swift Implementation Notes](#6-swift-implementation-notes)

---

## 1. Anthropic Claude API

### Endpoint

```
POST https://api.anthropic.com/v1/messages
```

### Required Headers

```
x-api-key: <YOUR_API_KEY>
anthropic-version: 2023-06-01
content-type: application/json
```

### Current Models (February 2026)

| Model | API ID (alias) | API ID (dated) | Context | Max Output | Input $/MTok | Output $/MTok | Latency |
|-------|---------------|----------------|---------|------------|-------------|--------------|---------|
| **Opus 4.6** | `claude-opus-4-6` | `claude-opus-4-6` | 200K (1M beta) | 128K | $5 | $25 | Moderate |
| **Sonnet 4.5** | `claude-sonnet-4-5` | `claude-sonnet-4-5-20250929` | 200K (1M beta) | 64K | $3 | $15 | Fast |
| **Haiku 4.5** | `claude-haiku-4-5` | `claude-haiku-4-5-20251001` | 200K | 64K | $1 | $5 | Fastest |

Legacy (still available): Opus 4.5 (`claude-opus-4-5`), Opus 4.1, Sonnet 4, Opus 4, Haiku 3.5, Haiku 3.

Batch API: 50% discount on all token prices.
Long context (>200K input): 2x input price, 1.5x output price.
Prompt caching: Cache hits cost 10% of base input price; 5-min cache writes cost 1.25x; 1-hour writes cost 2x.

### Request: Send Message with Tool Definitions

```json
{
  "model": "claude-sonnet-4-5",
  "max_tokens": 4096,
  "system": "You are a genomics assistant.",
  "tools": [
    {
      "name": "search_genes",
      "description": "Search for genes by name, symbol, or description in the loaded genome assembly. Returns matching gene annotations with coordinates.",
      "input_schema": {
        "type": "object",
        "properties": {
          "query": {
            "type": "string",
            "description": "Gene name, symbol, or keyword to search for"
          },
          "chromosome": {
            "type": "string",
            "description": "Optional: limit search to a specific chromosome"
          }
        },
        "required": ["query"]
      }
    }
  ],
  "tool_choice": {"type": "auto"},
  "messages": [
    {
      "role": "user",
      "content": "Where is the TP53 gene located?"
    }
  ]
}
```

`tool_choice` options: `{"type": "auto"}` (default), `{"type": "any"}`, `{"type": "tool", "name": "..."}`, `{"type": "none"}`.

### Response: Model Requests Tool Use

The response has `stop_reason: "tool_use"` and contains `tool_use` content blocks:

```json
{
  "id": "msg_01Aq9w938a90dw8q",
  "type": "message",
  "model": "claude-sonnet-4-5-20250929",
  "role": "assistant",
  "stop_reason": "tool_use",
  "content": [
    {
      "type": "text",
      "text": "I'll search for the TP53 gene in the loaded assembly."
    },
    {
      "type": "tool_use",
      "id": "toolu_01A09q90qw90lq917835lq9",
      "name": "search_genes",
      "input": {
        "query": "TP53"
      }
    }
  ],
  "usage": {
    "input_tokens": 472,
    "output_tokens": 89
  }
}
```

Key fields in `tool_use` block:
- `id` -- unique identifier, must be referenced when sending results back
- `name` -- which tool the model wants to call
- `input` -- JSON object conforming to the tool's `input_schema`

### Sending Tool Results Back

Tool results are sent as a `user` message with `tool_result` content blocks. **All tool results must come FIRST in the content array, before any text.**

```json
{
  "role": "user",
  "content": [
    {
      "type": "tool_result",
      "tool_use_id": "toolu_01A09q90qw90lq917835lq9",
      "content": "Found 1 result: TP53 (tumor protein p53) located on chr17:7,668,402-7,687,550 (GRCh38), minus strand. Type: protein_coding gene."
    }
  ]
}
```

For errors:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_01A09q90qw90lq917835lq9",
  "content": "Error: No genome assembly is currently loaded.",
  "is_error": true
}
```

Tool results can also contain structured content (images, documents):

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_01A09q90qw90lq917835lq9",
  "content": [
    {"type": "text", "text": "Gene found on chr17"},
    {"type": "image", "source": {"type": "base64", "media_type": "image/png", "data": "..."}}
  ]
}
```

### Full Conversation Flow

The complete message array for a tool-use round trip:

```json
{
  "model": "claude-sonnet-4-5",
  "max_tokens": 4096,
  "tools": [ /* ... tool definitions ... */ ],
  "messages": [
    {"role": "user", "content": "Where is the TP53 gene?"},
    {
      "role": "assistant",
      "content": [
        {"type": "text", "text": "I'll search for TP53."},
        {"type": "tool_use", "id": "toolu_01A09q", "name": "search_genes", "input": {"query": "TP53"}}
      ]
    },
    {
      "role": "user",
      "content": [
        {"type": "tool_result", "tool_use_id": "toolu_01A09q", "content": "TP53 on chr17:7668402-7687550"}
      ]
    }
  ]
}
```

### Parallel Tool Calls

Claude can return multiple `tool_use` blocks in a single response. All results must be in a **single** `user` message:

```json
{
  "role": "user",
  "content": [
    {"type": "tool_result", "tool_use_id": "toolu_01", "content": "result 1"},
    {"type": "tool_result", "tool_use_id": "toolu_02", "content": "result 2"}
  ]
}
```

### Streaming Tool Use (SSE)

Set `"stream": true` in the request. Tool use appears as content blocks in the SSE stream:

```
event: content_block_start
data: {"type":"content_block_start","index":1,"content_block":{"type":"tool_use","id":"toolu_01T1x1fJ34q","name":"get_weather","input":{}}}

event: content_block_delta
data: {"type":"content_block_delta","index":1,"delta":{"type":"input_json_delta","partial_json":"{\"location\":"}}

event: content_block_delta
data: {"type":"content_block_delta","index":1,"delta":{"type":"input_json_delta","partial_json":" \"San Francisco, CA\"}"}}

event: content_block_stop
data: {"type":"content_block_stop","index":1}

event: message_delta
data: {"type":"message_delta","delta":{"stop_reason":"tool_use"}}
```

**Key streaming details:**
- Tool input arrives as `input_json_delta` events with `partial_json` strings
- Accumulate `partial_json` strings, parse JSON after `content_block_stop`
- `stop_reason` in `message_delta` will be `"tool_use"`
- Text content blocks stream with `text_delta` as usual

### Structured Outputs (Strict Mode)

Add `"strict": true` to tool definitions to guarantee schema-valid tool inputs:

```json
{
  "name": "search_genes",
  "description": "...",
  "input_schema": { /* ... */ },
  "strict": true
}
```

---

## 2. OpenAI API

OpenAI now has **two** APIs. The **Chat Completions** API is the established one; the newer **Responses API** is the recommended path forward.

### Chat Completions API

#### Endpoint

```
POST https://api.openai.com/v1/chat/completions
```

#### Required Headers

```
Authorization: Bearer <YOUR_API_KEY>
Content-Type: application/json
```

### Responses API

#### Endpoint

```
POST https://api.openai.com/v1/responses
```

Same headers as Chat Completions.

### Current Models (February 2026)

| Model | API ID | Context | Input $/MTok | Output $/MTok | Notes |
|-------|--------|---------|-------------|--------------|-------|
| **GPT-5.2** | `gpt-5.2` | -- | $1.75 | $14.00 | Latest flagship |
| **GPT-5** | `gpt-5` | -- | $1.25 | $10.00 | Reasoning model (succeeded o3) |
| **GPT-5 mini** | `gpt-5-mini` | -- | $0.25 | $2.00 | Succeeded o4-mini |
| **GPT-4.1** | `gpt-4.1` | 1M | $2.00 | $8.00 | Best non-reasoning, great tool use |
| **GPT-4.1 mini** | `gpt-4.1-mini` | 1M | $0.40 | $1.60 | Fast + cheap |
| **GPT-4.1 nano** | `gpt-4.1-nano` | 1M | $0.10 | $0.40 | Fastest + cheapest |
| **GPT-4o** | `gpt-4o` | 128K | $2.50 | $10.00 | Multimodal flagship (legacy) |
| **GPT-4o mini** | `gpt-4o-mini` | 128K | $0.15 | $0.60 | Budget option (legacy) |
| **o3** | `o3` | -- | $2.00 | $8.00 | Reasoning (being succeeded by GPT-5) |
| **o4-mini** | `o4-mini` | -- | -- | -- | Fast reasoning (being succeeded) |

### Chat Completions: Request with Tools

```json
{
  "model": "gpt-4.1",
  "messages": [
    {"role": "system", "content": "You are a genomics assistant."},
    {"role": "user", "content": "Where is the TP53 gene?"}
  ],
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "search_genes",
        "description": "Search for genes by name or symbol in the loaded genome.",
        "parameters": {
          "type": "object",
          "properties": {
            "query": {
              "type": "string",
              "description": "Gene name or symbol"
            }
          },
          "required": ["query"],
          "additionalProperties": false
        },
        "strict": true
      }
    }
  ],
  "tool_choice": "auto"
}
```

`tool_choice` options: `"auto"` (default), `"required"`, `"none"`, or `{"type": "function", "function": {"name": "search_genes"}}`.

### Chat Completions: Response with Tool Call

```json
{
  "id": "chatcmpl-abc123",
  "object": "chat.completion",
  "model": "gpt-4.1",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "tool_calls": [
          {
            "id": "call_12345xyz",
            "type": "function",
            "function": {
              "name": "search_genes",
              "arguments": "{\"query\": \"TP53\"}"
            }
          }
        ]
      },
      "finish_reason": "tool_calls"
    }
  ],
  "usage": {
    "prompt_tokens": 82,
    "completion_tokens": 17,
    "total_tokens": 99
  }
}
```

Key differences from Anthropic:
- Tool calls are in `message.tool_calls` array (not content blocks)
- `function.arguments` is a JSON **string** (not a parsed object)
- `finish_reason` is `"tool_calls"` (not `"tool_use"`)

### Chat Completions: Sending Tool Results

Tool results use `role: "tool"` messages (not embedded in `user` messages):

```json
{
  "role": "tool",
  "tool_call_id": "call_12345xyz",
  "content": "TP53 on chr17:7,668,402-7,687,550 (GRCh38)"
}
```

Full conversation flow:

```json
{
  "model": "gpt-4.1",
  "tools": [ /* ... */ ],
  "messages": [
    {"role": "system", "content": "You are a genomics assistant."},
    {"role": "user", "content": "Where is TP53?"},
    {
      "role": "assistant",
      "content": null,
      "tool_calls": [
        {"id": "call_12345xyz", "type": "function", "function": {"name": "search_genes", "arguments": "{\"query\":\"TP53\"}"}}
      ]
    },
    {
      "role": "tool",
      "tool_call_id": "call_12345xyz",
      "content": "TP53 on chr17:7,668,402-7,687,550"
    }
  ]
}
```

### Responses API: Request with Tools

The Responses API uses a different structure:

```json
{
  "model": "gpt-4.1",
  "input": [
    {"role": "user", "content": "Where is TP53?"}
  ],
  "tools": [
    {
      "type": "function",
      "name": "search_genes",
      "description": "Search for genes by name or symbol.",
      "parameters": {
        "type": "object",
        "properties": {
          "query": {"type": "string"}
        },
        "required": ["query"]
      }
    }
  ]
}
```

Note: In the Responses API, `function` is not nested -- `name`, `description`, `parameters` are at the tool level.

### Responses API: Response with Function Call

```json
{
  "output": [
    {
      "type": "function_call",
      "call_id": "call_12345xyz",
      "name": "search_genes",
      "arguments": "{\"query\": \"TP53\"}"
    }
  ]
}
```

### Responses API: Sending Results Back

```json
{
  "model": "gpt-4.1",
  "input": [
    {"type": "function_call_output", "call_id": "call_12345xyz", "output": "TP53 on chr17:7668402-7687550"}
  ]
}
```

### Streaming (Chat Completions)

Set `"stream": true`. Tool calls arrive in chunked `delta` objects:

```json
{
  "choices": [{
    "delta": {
      "tool_calls": [{
        "index": 0,
        "id": "call_12345xyz",
        "type": "function",
        "function": {
          "name": "search_genes",
          "arguments": ""
        }
      }]
    }
  }]
}
```

Subsequent chunks append to `arguments`:

```json
{
  "choices": [{
    "delta": {
      "tool_calls": [{
        "index": 0,
        "function": {
          "arguments": "{\"quer"
        }
      }]
    }
  }]
}
```

---

## 3. Google Gemini API

### Endpoint

```
POST https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:generateContent
```

For streaming:
```
POST https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:streamGenerateContent?alt=sse
```

### Required Headers

```
x-goog-api-key: <YOUR_API_KEY>
Content-Type: application/json
```

Alternatively, pass the key as a query parameter: `?key=<YOUR_API_KEY>`

### Current Models (February 2026)

| Model | API ID | Context | Max Output | Input $/MTok | Output $/MTok | Status |
|-------|--------|---------|------------|-------------|--------------|--------|
| **Gemini 3 Pro Preview** | `gemini-3-pro-preview` | 1M | 65K | $2.00 | $12.00 | Preview |
| **Gemini 3 Flash Preview** | `gemini-3-flash-preview` | 1M | 65K | $0.50 | $3.00 | Preview |
| **Gemini 2.5 Pro** | `gemini-2.5-pro` | 1M | 65K | $1.25 | $10.00 | Stable |
| **Gemini 2.5 Flash** | `gemini-2.5-flash` | 1M | 65K | $0.30 | $2.50 | Stable |
| **Gemini 2.5 Flash-Lite** | `gemini-2.5-flash-lite` | 1M | 65K | $0.10 | $0.40 | Stable |
| **Gemini 2.0 Flash** | `gemini-2.0-flash` | 1M | 8K | $0.10 | $0.40 | Deprecated 2026-03-31 |

All models above support function calling. Gemini has a **free tier** for low-volume usage.

### Request: Send Message with Function Declarations

```json
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "Where is the TP53 gene located?"
        }
      ]
    }
  ],
  "tools": [
    {
      "functionDeclarations": [
        {
          "name": "search_genes",
          "description": "Search for genes by name or symbol in the loaded genome assembly.",
          "parameters": {
            "type": "object",
            "properties": {
              "query": {
                "type": "string",
                "description": "Gene name or symbol to search for"
              },
              "chromosome": {
                "type": "string",
                "description": "Optional: limit to a specific chromosome"
              }
            },
            "required": ["query"]
          }
        }
      ]
    }
  ],
  "toolConfig": {
    "functionCallingConfig": {
      "mode": "AUTO"
    }
  }
}
```

`functionCallingConfig.mode` options: `"AUTO"` (default), `"ANY"`, `"NONE"`.

### Response: Model Requests Function Call

```json
{
  "candidates": [
    {
      "content": {
        "role": "model",
        "parts": [
          {
            "functionCall": {
              "name": "search_genes",
              "args": {
                "query": "TP53"
              }
            }
          }
        ]
      },
      "finishReason": "STOP"
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 42,
    "candidatesTokenCount": 12,
    "totalTokenCount": 54
  }
}
```

Key differences:
- `functionCall` (camelCase) with `args` (already parsed object, not a string)
- Nested inside `candidates[0].content.parts[]`
- No separate call ID -- function calls are tracked by name in the conversation

### Sending Function Results Back

Add the model's response AND the function result to the `contents` array:

```json
{
  "contents": [
    {
      "role": "user",
      "parts": [{"text": "Where is TP53?"}]
    },
    {
      "role": "model",
      "parts": [
        {
          "functionCall": {
            "name": "search_genes",
            "args": {"query": "TP53"}
          }
        }
      ]
    },
    {
      "role": "user",
      "parts": [
        {
          "functionResponse": {
            "name": "search_genes",
            "response": {
              "result": "TP53 (tumor protein p53) on chr17:7,668,402-7,687,550 (GRCh38), minus strand."
            }
          }
        }
      ]
    }
  ],
  "tools": [ /* same tool declarations */ ]
}
```

Key difference: Function results are sent as `functionResponse` parts in a `user` role message. The `response` field is a free-form JSON object (not just a string).

### Streaming

Use the `streamGenerateContent` endpoint with `?alt=sse`. Events arrive as SSE with JSON `candidates` chunks similar to the non-streaming response.

---

## 4. Cross-Provider Comparison

### Terminology Mapping

| Concept | Anthropic | OpenAI (Chat) | OpenAI (Responses) | Gemini |
|---------|-----------|---------------|-------------------|--------|
| Tool definition | `tools[].input_schema` | `tools[].function.parameters` | `tools[].parameters` | `tools[].functionDeclarations[].parameters` |
| Model wants tool | `stop_reason: "tool_use"` | `finish_reason: "tool_calls"` | output has `function_call` | `finishReason: "STOP"` + `functionCall` in parts |
| Tool call ID | `tool_use.id` | `tool_calls[].id` | `function_call.call_id` | (none -- matched by name) |
| Tool arguments | parsed JSON object | JSON string | JSON string | parsed JSON object |
| Result message role | `user` (with `tool_result` block) | `tool` | `function_call_output` input item | `user` (with `functionResponse` part) |
| Force specific tool | `tool_choice.type: "tool"` | `tool_choice: {function: {name}}` | similar | `functionCallingConfig.mode: "ANY"` |

### Key Architectural Differences

1. **Anthropic**: Content blocks model. Messages contain arrays of typed blocks (`text`, `tool_use`, `tool_result`). Tool results embedded in `user` messages.

2. **OpenAI Chat Completions**: Separate `tool_calls` field on assistant message. Results use dedicated `tool` role. Arguments are JSON strings.

3. **OpenAI Responses API**: Flat output items. Function calls and results are separate items with `call_id` references.

4. **Gemini**: Parts-based model. Everything is `parts[]` within `contents[]`. Function calls and responses are part types. No explicit call IDs.

### Price Comparison (Smart + Fast tier)

| Provider | Model | Input $/MTok | Output $/MTok | Relative Cost |
|----------|-------|-------------|--------------|---------------|
| Anthropic | Haiku 4.5 | $1.00 | $5.00 | Medium |
| Anthropic | Sonnet 4.5 | $3.00 | $15.00 | Higher |
| OpenAI | GPT-4.1 mini | $0.40 | $1.60 | Low |
| OpenAI | GPT-4.1 nano | $0.10 | $0.40 | Very Low |
| Google | Gemini 2.5 Flash | $0.30 | $2.50 | Low |
| Google | Gemini 2.5 Flash-Lite | $0.10 | $0.40 | Very Low |
| Google | Gemini 3 Flash Preview | $0.50 | $3.00 | Low-Medium |

---

## 5. Recommendation for Genomics Tool-Use App

### Primary Recommendation: Claude Sonnet 4.5

**Why Sonnet 4.5 for genomics tool-use:**
- Strong biological/scientific knowledge (training data cutoff Jan 2025, broad scientific corpus)
- Excellent tool-use support with parallel tool calling
- Good balance of speed and intelligence ($3/$15 per MTok)
- 200K context window sufficient for most genomics queries
- Fast latency tier -- suitable for interactive use
- Strict mode available for guaranteed schema-valid tool inputs
- Claude models consistently rank highly on science/biology benchmarks

### Budget/Speed Alternative: Claude Haiku 4.5

For cases where speed is paramount and questions are straightforward:
- $1/$5 per MTok -- 3x cheaper than Sonnet
- Fastest latency in the Claude family
- Still supports all tool-use features
- Good for simple lookups ("where is gene X?", "what variants are at position Y?")
- May struggle with complex multi-step genomics reasoning

### Cross-Provider Alternatives

| Use Case | Recommended | Why |
|----------|-------------|-----|
| Best quality + genomics knowledge | Claude Sonnet 4.5 or Opus 4.6 | Deep scientific training, great tool use |
| Cheapest viable option | Gemini 2.5 Flash-Lite ($0.10/$0.40) | Free tier available, 1M context |
| Best tool-use reliability | GPT-4.1 ($2/$8) | Specifically optimized for tool calling |
| Fastest + cheapest at scale | GPT-4.1 nano ($0.10/$0.40) | Fastest OpenAI model |
| Maximum context window | Gemini 2.5 Pro (1M standard) | No beta flag needed for 1M context |

### Multi-Provider Strategy

For a production genomics app, consider supporting multiple providers:

1. **Default:** Claude Sonnet 4.5 -- best overall quality for biology questions
2. **Fast/cheap fallback:** Gemini 2.5 Flash -- low cost, 1M context, free tier for development
3. **Power users:** Claude Opus 4.6 -- for complex multi-step analysis

---

## 6. Swift Implementation Notes

### Unified Tool Protocol

Define a protocol that abstracts across providers:

```swift
protocol LLMTool {
    var name: String { get }
    var description: String { get }
    var parameterSchema: [String: Any] { get }  // JSON Schema
    var requiredParameters: [String] { get }
}

protocol LLMToolCall {
    var callID: String { get }
    var toolName: String { get }
    var arguments: [String: Any] { get }
}

protocol LLMToolResult {
    var callID: String { get }
    var content: String { get }
    var isError: Bool { get }
}
```

### Provider-Specific Serialization

Each provider needs its own serializer for tool definitions:

```swift
// Anthropic: tools[].input_schema
func anthropicToolJSON(_ tool: LLMTool) -> [String: Any] {
    [
        "name": tool.name,
        "description": tool.description,
        "input_schema": [
            "type": "object",
            "properties": tool.parameterSchema,
            "required": tool.requiredParameters
        ]
    ]
}

// OpenAI Chat: tools[].function.parameters
func openAIToolJSON(_ tool: LLMTool) -> [String: Any] {
    [
        "type": "function",
        "function": [
            "name": tool.name,
            "description": tool.description,
            "parameters": [
                "type": "object",
                "properties": tool.parameterSchema,
                "required": tool.requiredParameters,
                "additionalProperties": false
            ],
            "strict": true
        ]
    ]
}

// Gemini: tools[].functionDeclarations[]
func geminiToolJSON(_ tool: LLMTool) -> [String: Any] {
    [
        "functionDeclarations": [[
            "name": tool.name,
            "description": tool.description,
            "parameters": [
                "type": "object",
                "properties": tool.parameterSchema,
                "required": tool.requiredParameters
            ]
        ]]
    ]
}
```

### Parsing Tool Calls from Responses

```swift
// Anthropic: content blocks with type "tool_use"
// - id, name, input (parsed JSON object)

// OpenAI Chat: message.tool_calls[]
// - id, function.name, function.arguments (JSON STRING -- must parse)

// Gemini: candidates[0].content.parts[] with functionCall
// - functionCall.name, functionCall.args (parsed JSON object)
// - NO call ID -- generate one client-side or use name as key
```

### SSE Streaming Considerations

For URLSession-based SSE streaming in Swift:

- All three providers use standard SSE format (`event:` + `data:` lines)
- Anthropic: Accumulate `partial_json` from `input_json_delta` events
- OpenAI: Accumulate `arguments` string fragments from delta chunks
- Gemini: Use `streamGenerateContent?alt=sse` endpoint

### Gemini Call ID Workaround

Gemini does not provide call IDs for function calls. When the model returns multiple parallel function calls, match results by function name. If the same function is called multiple times, use the order of appearance:

```swift
// Generate synthetic call IDs for Gemini
let callID = "\(functionName)_\(index)"
```

---

## Sources

- [Anthropic: How to implement tool use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/implement-tool-use)
- [Anthropic: Tool use overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
- [Anthropic: Models overview](https://platform.claude.com/docs/en/about-claude/models/overview)
- [Anthropic: Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- [Anthropic: Streaming](https://platform.claude.com/docs/en/build-with-claude/streaming)
- [OpenAI: Function calling guide](https://developers.openai.com/api/docs/guides/function-calling/)
- [OpenAI: Responses API](https://platform.openai.com/docs/api-reference/responses)
- [OpenAI: Pricing](https://developers.openai.com/api/docs/pricing/)
- [OpenAI: Models](https://platform.openai.com/docs/models)
- [Google: Function calling with Gemini](https://ai.google.dev/gemini-api/docs/function-calling)
- [Google: Gemini models](https://ai.google.dev/gemini-api/docs/models)
- [Google: Gemini pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Google: Gemini 3 Developer Guide](https://ai.google.dev/gemini-api/docs/gemini-3)
