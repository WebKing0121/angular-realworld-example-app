import { NgModule } from "@angular/core";
import { MatFormFieldModule } from "@angular/material/form-field";
import { HttpClientModule} from '@angular/common/http';
import { MatInputModule } from "@angular/material/input";
import { MatButtonModule } from "@angular/material/button";
import { AngularEditorModule } from '@kolkov/angular-editor';

import { EditorComponent } from "./editor.component";
import { EditableArticleResolver } from "./editable-article-resolver.service";
import { SharedModule } from "../shared";
import { EditorRoutingModule } from "./editor-routing.module";
@NgModule({
  imports: [
    AngularEditorModule,
    SharedModule,
    EditorRoutingModule,
    HttpClientModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
  ],
  declarations: [EditorComponent],
  providers: [EditableArticleResolver],
})
export class EditorModule {}
