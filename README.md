Ethereum Challenges

Repository này chứa mã nguồn giải pháp cho các challenge trong **SpeedRun Ethereum**. Mỗi challenge được phát triển và lưu trữ trên một nhánh (branch) riêng biệt.


## 🚀 Quy trình chạy code

Vì cấu trúc của các challenge trong Scaffold-ETH là giống nhau, bạn hãy thực hiện theo đúng trình tự dưới đây để chạy bất kỳ challenge nào trên môi trường localhost.

### Bước 1: Clone & Cài đặt
```bash
git clone https://github.com/phamhoanggiang24062004/speedrunethereum
cd speedrunethereum
yarn install
```

### Bước 2: Chọn challenge
Mỗi challenge nằm ở một nhánh riêng, chuyển sang nhánh tương ứng trước khi chạy.
```bash
git checkout challenge-decentralized-staking
yarn install  # Chạy lại lệnh này để cập nhật dependencies cho nhánh mới
```
### Bước 3: Khởi chạy môi trường
Bạn cần mở 3 cửa sổ Terminal song song, thực hiện lần lượt các lệnh:
- **Terminal 1**: Khởi tạo mạng Blockchain ảo nội bộ
```bash
yarn chain
```
- **Terminal 2**: Compile và deploy smart contract lên mạng ảo
```bash
yarn deploy
```

- **Terminal 3**: Khởi chạy giao diện Frontend Web tại địa chỉ localhost
```bash
yarn start
```
Sau khi chạy xong 3 lệnh trên, truy cập http://localhost:3000 để tương tác với web và thực hiện từng yêu cầu trong các checkpoint của challenge.


## 🧪 Hướng dẫn chạy Test (Automated Testing)
Việc chạy test nhằm mục đích chấm điểm logic của Smart Contract mà không cần khởi chạy giao diện Web. Kết quả mong đợi tất cả các test case hiển thị tích xanh (passing)
```bash
# Chạy toàn bộ test case của challenge hiện tại
yarn test
```

## 🌐 Hướng dẫn Deploy lên Public Testnet (Sepolia)
Quy trình để deploy lên mạng thử nghiệm công khai:
1. Tạo ví deployder:
```bash
yarn generate
```
2. Kiểm tra tài khoản và nạp ETH: Ban đầu ví chưa có ETH, có thể truy cập các faucet Sepolia để nạp ETH miễn phí như: 
   - Alchemy Sepolia Faucet  
   - Google Cloud Web3  
   - QuickNode Faucet  
   - Sepolia PoW Faucet  
3. Deploy Contract lên Sepolia:
```bash
yarn deploy --network sepolia
```
4. Xác thực Contract (Verify):
```bash
yarn verify --network sepolia
```
5. Deploy Frontend (Vercel):
```bash
yarn vercel
```

⚠️ Lưu ý: Nếu quá trình deploy frontend bị lỗi 404 Not Found thì có thể thử cách sau. Trong phần challenge đang deploy trên Vercel, chọn mục Settings -> Build and Deployment. Sau đó thực hiện cấu hình trong mục Framework Settings và Root Directory như trong ảnh dưới:

<img width="1136" height="764" alt="Screenshot 2025-12-30 000225" src="https://github.com/user-attachments/assets/c7bb87c0-b77f-4ba2-871b-4b78cf1ff4a2" />
<img width="1153" height="421" alt="Screenshot 2025-12-30 000301" src="https://github.com/user-attachments/assets/cc9e8689-a3d5-4930-bf5b-b0ac58da1824" />

### 📝 Hướng dẫn Submit challenge
Sau khi hoàn tất deploy, truy cập lại trang Challenge trên SpeedRunEthereum và nhập thông tin:
- **Deployed URL:** Đường dẫn Frontend đã deploy (ví dụ: `https://token-vendor.vercel.app`).
- **Contract URL:** Đường dẫn Smart Contract trên Sepolia Etherscan.



