# 🔬 Solana Validator Transaction Ordering Benchmark

An empirical measurement suite for analyzing how Solana Mainnet validators order transactions inside blocks.

Built for the **Superteam Earn — Inside the Block Challenge ($2,500 USDC)**.

---

## 🎯 The Question & Core Finding

> **By what rule does a validator order transactions in its block?**

### Empirical Conclusion:
* **Solana does NOT follow a single monotonic priority fee sort order.**
* Unlike Ethereum's single-threaded mempool (where `SortByGasPriceDescending` dominates), Solana's **BankingStage scheduler** distributes incoming transactions across **multiple parallel worker threads**.
* Each worker thread locks non-conflicting accounts concurrently. Consequently:
  1. High priority fee transactions execute first **within their assigned thread queue**.
  2. If thread A processes independent accounts faster than thread B, lower-fee transactions on thread A can commit to the block **ahead of higher-fee transactions waiting on thread B**.
  3. Vote transactions and consensus control packets are prioritized and distributed throughout the block.

---

## ⚡ Quick Start (One Command)

### Using Docker Compose (Recommended)
```bash
docker compose up
```

### Using Local Python CLI
```bash
python3 main.py --dry-run --samples 6
```

All raw measurements and signatures will be written to:
* `data/raw_measurements.json`
* `reports/ANALYSIS_REPORT.md`

---

## 🛡️ Safety & Dry-Run Invariants
* **Dry-Run by Default**: Zero SOL is spent during standard execution. All measurements are derived non-destructively from Solana Mainnet RPC block parsing.
* **No Keys in Repo**: Any live measurement keys are strictly loaded via environment variables or Docker volumes.

---

## 📊 Methodology & Verification

Judges can verify any block in the generated report using standard Solana RPC:
```bash
curl -X POST -H "Content-Type: application/json" -d '{
  "jsonrpc": "2.0", "id": 1,
  "method": "getBlock",
  "params": [<SLOT_NUMBER>, {"encoding": "jsonParsed", "transactionDetails": "signatures"}]
}' https://api.mainnet-beta.solana.com
```

---

## 👤 Author
* **Rizul Chauhan** ([@RizulChauhan](https://github.com/RizulChauhan))
* Built with Antigravity Autonomous Systems Engineer
