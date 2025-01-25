import 'package:provider/provider.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'purchased_conversation_model.dart';

class PurchasedConversationWidget extends StatefulWidget {
  const PurchasedConversationWidget({
    Key? key,
    required this.productInfo,
  }) : super(key: key);

  /// 複数商品などの場合、List<DocumentReference>
  final List<DocumentReference>? productInfo;

  @override
  State<PurchasedConversationWidget> createState() =>
      _PurchasedConversationWidgetState();
}

class _PurchasedConversationWidgetState
    extends State<PurchasedConversationWidget> {
  late PurchasedConversationModel _model;

  bool _isCompleted = false; // レビューがあるかどうか
  ReviewsRecord? _reviewData;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PurchasedConversationModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.userCommentTextController ??= TextEditingController();
    _model.userCommentFocusNode ??= FocusNode();

    _checkIfCompleted(); // レビューがあるかどうか初期チェック
  }

  Future<void> _checkIfCompleted() async {
    if (widget.productInfo == null || widget.productInfo!.isEmpty) {
      return;
    }
    // 既に reviews に同じ product を含むレコードがあれば「完了」とみなす
    final existingReviews = await queryReviewsRecordOnce(
      queryBuilder: (q) =>
          q.whereArrayContainsAny('product', widget.productInfo!).limit(1),
    );
    if (existingReviews.isNotEmpty) {
      setState(() {
        _isCompleted = true;
        _reviewData = existingReviews.first;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// 取引を終了 => reviews に書き込み
  Future<void> _completeTransaction() async {
    if (widget.productInfo == null) return;
    // 新規レビュー作成
    await ReviewsRecord.collection.doc().set({
      ...createReviewsRecordData(
        user: currentUserReference,
        productUser: FFAppState().productUser,
        evaluation: FFAppState().evaluation,
        review: _model.textController1.text,
      ),
      'product': widget.productInfo,
    });

    // 通知 or Toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '取引を終了しました',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ),
    );

    // ローカル状態
    setState(() {
      _isCompleted = true;
      _reviewData = ReviewsRecord.getDocumentFromData(
        {
          'user': currentUserReference,
          'product': widget.productInfo,
          'evaluation': FFAppState().evaluation,
          'review': _model.textController1.text,
        },
        ReviewsRecord.collection.doc(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          leading: FlutterFlowIconButton(
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'コメント',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // 上部にレビュー欄 or 「終了済み」表示を分岐
              if (_isCompleted)
                _buildCompletedHeader()
              else
                _buildReviewSection(),

              const Divider(thickness: 1),
              // コメント一覧(Expandedでスクロール)
              Expanded(
                child: _buildConversationList(),
              ),

              // 下部: 送信用テキストボックス (未完了時のみ)
              if (!_isCompleted) _buildMessageInput() else Container(),
            ],
          ),
        ),
      ),
    );
  }

  /// 終了していない場合のUI(評価ボタン + テキスト + 終了ボタン)
  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 良かった／悪かった
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FFButtonWidget(
                onPressed: () {
                  FFAppState().evaluation = 5.0;
                  setState(() {});
                },
                text: '良かった',
                options: FFButtonOptions(
                  width: 100,
                  height: 40,
                  color: const Color(0xFF507583),
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
              FFButtonWidget(
                onPressed: () {
                  FFAppState().evaluation = 0.0;
                  setState(() {});
                },
                text: '悪かった',
                options: FFButtonOptions(
                  width: 100,
                  height: 40,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _model.textController1,
            focusNode: _model.textFieldFocusNode,
            decoration: InputDecoration(
              hintText: 'レビューコメント',
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          const SizedBox(height: 8),
          FFButtonWidget(
            onPressed: () async {
              await _completeTransaction();
            },
            text: '取引を終了し、レビューを投稿する',
            options: FFButtonOptions(
              width: MediaQuery.sizeOf(context).width,
              height: 40.0,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: const Color(0xFF507583),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// 終了済みの場合のUI
  Widget _buildCompletedHeader() {
    final eval = _reviewData?.evaluation ?? 0.0;
    final reviewText = _reviewData?.review ?? '';

    return Container(
      width: double.infinity,
      color: Colors.green[100],
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'この取引は終了しました。',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(eval > 0 ? '評価: 良かった' : '評価: 悪かった'),
          Text('コメント: $reviewText'),
        ],
      ),
    );
  }

  /// コメント一覧
  Widget _buildConversationList() {
    return StreamBuilder<List<PurchasedConversationsRecord>>(
      stream: queryPurchasedConversationsRecord(
        queryBuilder: (q) => q
            .whereArrayContainsAny('product', widget.productInfo ?? [])
            .orderBy('time_stump'),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final conversation = snapshot.data!;
        if (conversation.isEmpty) {
          return const Center(child: Text('まだコメントはありません'));
        }

        return ListView.builder(
          itemCount: conversation.length,
          itemBuilder: (context, index) {
            final conv = conversation[index];
            return _buildCommentBubble(conv);
          },
        );
      },
    );
  }

  /// コメント1件分
  Widget _buildCommentBubble(PurchasedConversationsRecord record) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(record.user!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final userData = snapshot.data!;
        final isMine = (record.user == currentUserReference);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              // user名 + アイコン
              Row(
                mainAxisAlignment:
                    isMine ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (!isMine)
                    Text(userData.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  if (!isMine) const SizedBox(width: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      userData.image.isNotEmpty
                          ? userData.image
                          : 'https://firebasestorage.googleapis.com/v0/b/furugi-with-template-40pf0j.appspot.com/o/users%2Fdefault_image%2Fuser_no_image.png?alt=media&token=624ae0c5-c31b-4908-82e8-c79e0e996d7a',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isMine) const SizedBox(width: 6),
                  if (isMine)
                    Text(userData.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 4),
              // メッセージ
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  record.comment,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 送信欄 (画面下固定したい場合は Scaffold の bottomNavigationBar に置くなど)
  Widget _buildMessageInput() {
    return Container(
      color: FlutterFlowTheme.of(context).secondaryBackground,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _model.userCommentTextController,
              focusNode: _model.userCommentFocusNode,
              decoration: InputDecoration(
                hintText: 'メッセージを入力',
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FFButtonWidget(
            onPressed: () async {
              final text = _model.userCommentTextController.text.trim();
              if (text.isEmpty) return;
              await PurchasedConversationsRecord.collection.doc().set({
                ...createPurchasedConversationsRecordData(
                  comment: text,
                  user: currentUserReference,
                ),
                'time_stump': FieldValue.serverTimestamp(),
                'product': widget.productInfo ?? [],
              });
              _model.userCommentTextController?.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('コメントを送信しました')),
              );
            },
            text: '送信',
            options: FFButtonOptions(
              width: 60,
              height: 45,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
